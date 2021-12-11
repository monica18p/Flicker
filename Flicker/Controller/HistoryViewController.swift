//
//  HistoryViewController.swift
//  Flicker
//
//  Created by Monica Pandey on 04/12/2021.
//

import UIKit

class HistoryViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var noHistoryLbl: UILabel!
  var searchHistory: SearchHistory!
    override func viewDidLoad() {
        super.viewDidLoad()
      loadHistoryInstance()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configUI()
    tableView.reloadData()
  }
  
  private func configUI() {
    if searchHistory.getHistory().count > 0 {
      noHistoryLbl.isHidden = true
      tableView.isHidden = false
    } else {
      noHistoryLbl.isHidden = false
      tableView.isHidden = true
    }
  }
  
  private func loadHistoryInstance() {
    if let tabBarCtrl = self.tabBarController as? TabBarController {
      searchHistory = tabBarCtrl.searchHistory
    } else {
      fatalError("Missing TabBarController")
    }
  }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchHistory.getHistory().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
    let query = searchHistory.getHistory()[indexPath.row].query
    if #available(iOS 14.0, *) {
      var content = cell.defaultContentConfiguration()
      content.text = query
      content.secondaryText = "Tap to search again"
      cell.contentConfiguration = content
    } else {
      cell.textLabel?.text = query
      cell.detailTextLabel?.text = "Tap to search again"
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let vc = self.tabBarController?.viewControllers?.filter({ vc in
      return vc is SearchViewController
    })
    guard let searchVC = vc?.first as? SearchViewController else { return }
    
    searchVC.searchBar.searchTextField.text = searchHistory.getHistory()[indexPath.row].query
    searchVC.searchBar.delegate?.searchBarSearchButtonClicked?(searchVC.searchBar)
    
    self.tabBarController?.selectedIndex = 0
  }
}
