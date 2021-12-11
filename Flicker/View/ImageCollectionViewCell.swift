//
//  ImageCollectionViewCell.swift
//  Flicker
//
//  Created by Monica Pandey on 04/12/2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  var currentIndexPath: IndexPath?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
      super.prepareForReuse()
      imageView.image = nil
      currentIndexPath = nil
  }
}

// MARK: - Image Resize Extension

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let widthRatio  = (targetSize.width  / size.width)
        let heightRatio = (targetSize.height / size.height)
        let effectiveRatio = max(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * effectiveRatio, height: size.height * effectiveRatio)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
