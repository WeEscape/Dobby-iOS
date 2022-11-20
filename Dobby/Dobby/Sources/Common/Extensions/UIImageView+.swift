//
//  UIImageView+.swift
//  Dobby
//
//  Created by yongmin lee on 11/20/22.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(urlString: String) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self.image = image
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource)
                }
            case .failure(let error):
                BeaverLog.debug(error)
            }
        }
    }
}
