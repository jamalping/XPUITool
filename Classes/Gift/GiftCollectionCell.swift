//
//  GiftCollectionCell.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class GiftCollectionCell: UICollectionViewCell {
    class var cellIdenti: String {
        return "\(self)"
    }
    var data: GiftModel? {
        didSet {
            guard let model = data else {
                return
            }
            self.imageView.image = UIImage.init(named: model.imageName ?? "testImg")
            self.titleLabel.text = model.title
            self.desLabel.text = model.describe
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
}
