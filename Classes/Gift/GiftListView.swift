//
//  GiftListView.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/13.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit
import XPUtil

let keyWindow = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first!

class GiftListView: UIView {
    
    let markView = UIView.init(frame: CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var dataSource: [GiftModel] = [GiftModel]() {
        didSet {
//            self.collectionView.reloadData()
        }
    }
    
    var didSelected: ((_ giftModel: GiftModel)->())?
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize.init(width: self.width/4, height: self.height/2)
        
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib.init(nibName: GiftCollectionCell.cellIdenti, bundle: nil), forCellWithReuseIdentifier: GiftCollectionCell.cellIdenti)

        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tap.delegate = self
        markView.addGestureRecognizer(tap)
        
        configPage()
    }
    
    func configPage() {
        self.top = markView.height - self.height
        self.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapAction() {
        self.hidden()
    }
    
    deinit {
        print("GiftListView deinit")
    }
    
    func show() {
        markView.addSubview(self)
        keyWindow.addSubview(self.markView)
        self.markView.alpha = 0
        
        UIView.animate(withDuration: 0.33, animations: {
            self.markView.top = 0
            self.markView.alpha = 1
        }) { (finish) in
            
        }
    }
    
    func hidden() {
        UIView.animate(withDuration: 0.33, animations: {
            self.markView.top = UIScreen.main.bounds.height
        }) { (finish) in
            self.removeFromSuperview()
            self.markView.removeFromSuperview()
        }
    }
}

extension GiftListView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GiftCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftCollectionCell.cellIdenti, for: indexPath) as! GiftCollectionCell
        let giftModel = self.dataSource[indexPath.row]
        cell.data = giftModel
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let giftModel = self.dataSource[indexPath.row]
        self.didSelected?(giftModel)
    }
}


// MARK: - 代理解决手势冲突
extension GiftListView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        if self.collectionView.frame.contains(touchPoint) {
            return false
        }
        return true
    }
}
