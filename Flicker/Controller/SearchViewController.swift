//
//  SearchViewController.swift
//  Flicker
//
//  Created by Monica Pandey on 04/12/2021.

import UIKit

class SearchViewController: UIViewController {

  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  var result: SearchResult? {
    didSet {
      collectionView.reloadData()
    }
  }
  var cacheManager = CacheManager()
  var searchHistory: SearchHistory!
  
   override func viewDidLoad() {
    super.viewDidLoad()
     collectionViewLayoutSetup()
     loadingIndicatorSetup()
     loadHistoryInstance()
  }
  
  private func collectionViewLayoutSetup() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 10
    layout.minimumInteritemSpacing = 10
    collectionView.setCollectionViewLayout(layout, animated: true)
  }
  
  private func resetSearchBarBehaviour() {
    searchBar.text = ""
    searchBar.resignFirstResponder()
  }
  
  private func resetCollectionview() {
    result = nil
    collectionView.reloadData()
  }
  
  private func loadingIndicatorSetup () {
    self.view.bringSubviewToFront(loadingIndicator)
    loadingIndicator.stopAnimating()
  }
  
  private func loadHistoryInstance() {
    if let tabBarCtrl = self.tabBarController as? TabBarController {
      searchHistory = tabBarCtrl.searchHistory
    } else {
      fatalError("Missing TabBarController")
    }
  }
  
  private func addHistoryQuery(searchText: String) {
    let history = History(query: searchText)
    searchHistory.addNewItem(item: history)
  }
  
  private func showAlert(msg: String) {
    let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
    let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(okBtn)
    self.present(alert, animated: true, completion: nil)
  }
  
}

extension SearchViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let photos = result?.photos else { return 0 }
    
    return photos.photo.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
    
    cell.currentIndexPath = indexPath
    let cellSize = self.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath)
    if let photos = result?.photos {
      Task {
        do {
          async let (image, index) = try await cacheManager.fetchImage(atIndex: indexPath.item, resizedTo: cellSize, photoInfo: photos.photo[indexPath.item])
          let (asyncImage, asyncIndex) = try await (image, index)
          
          guard let cellIndexPath = cell.currentIndexPath, cellIndexPath.item == asyncIndex else {
               //Discarding fetched image for item because the cell is no longer being used for that index path
              return
          }
          
          cell.imageView.image = asyncImage
        } catch {
          cell.imageView.image = UIImage(named: "warning-sign")
        }
        
      }
      
    }
    return cell
  }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let padding: CGFloat = 25
    let collectionCellSize = collectionView.frame.size.width - padding
    
    return CGSize(width: collectionCellSize/2, height: collectionCellSize/2)
    
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    resetSearchBarBehaviour()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    guard let text = searchBar.text else {
      showAlert(msg: APIError.SearchTextIsBlank.errorDescription)
      return
      
    }
    let searchText = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    if searchText.isEmpty == true {
      showAlert(msg: APIError.SearchTextIsBlank.errorDescription)
      return }
    
    addHistoryQuery(searchText: searchText)
    resetCollectionview()
    cacheManager.clearCache()
    loadingIndicator.startAnimating()
    
    Task {
      do {
        async let result = try await SearchImageAPIService.searchImage(searchText: searchText)
        let asyncResult = try await result
        self.result = asyncResult
        await MainActor.run {
          loadingIndicator.stopAnimating()
        }
      } catch {
        guard let e = error as? APIError else {
          await MainActor.run {
            loadingIndicator.stopAnimating()
            showAlert(msg: error.localizedDescription)
          }
          return
        }
        await MainActor.run {
          loadingIndicator.stopAnimating()
          showAlert(msg: e.errorDescription)
        }
        
      }
    }
  }
}
