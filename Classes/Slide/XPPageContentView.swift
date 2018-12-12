//
//  XPPageContentView.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/12.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

@objc protocol PageContentViewDelegate {
    func contentViewDidScroll(contentView :XPPageContentView, startIndex: CGFloat, endIndex: CGFloat)
}


class XPPageContentView: UIView {

    fileprivate let collectionCellIdenti = "collectionCellIdenti"
    
    weak var parentVC: UIViewController?
    var childVCArray = [UIViewController]()
    var startOffsetX: CGFloat = 0
    var isSelectBtn: Bool = true
    var isCanScroll: Bool = true
    weak var delegate: PageContentViewDelegate?
    
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex < 0 || Int(currentIndex) > self.childVCArray.count - 1 {
                return
            }
            self.collectionView.scrollToItem(at: IndexPath.init(row: Int(currentIndex), section: 0), at: UICollectionViewScrollPosition.right, animated: true)
        }
    }
    
    var contentViewDidScroll: ((_ contentView: XPPageContentView, _ startIndex: CGFloat, _ endIndex: CGFloat) -> ())?
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionCellIdenti)
        return collectionView
    }()
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController) {
        super.init(frame: frame)
        self.childVCArray = childVCs
        self.parentVC = parentVC
        
        self.childVCArray.forEach { (vc) in
            self.parentVC?.addChildViewController(vc)
        }
        
        self.addSubview(collectionView)
        
        collectionView.reloadData()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XPPageContentView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childVCArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdenti, for: indexPath)
        cell.contentView.subviews.forEach{ $0.removeFromSuperview()}
        let childVC = self.childVCArray[indexPath.row]
        childVC.view.frame = cell.bounds
        cell.contentView.addSubview(childVC.view)
        return cell
    }
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollView_w = scrollView.bounds.size.width
        let currentOffsetX = scrollView.contentOffset.x
        let startIndex = floor(startOffsetX/scrollView_w)
        let endIndex = floor(currentOffsetX/scrollView_w)
        if self.contentViewDidScroll == nil {
            self.delegate?.contentViewDidScroll(contentView: self, startIndex: startIndex, endIndex: endIndex)
        }else {
            self.contentViewDidScroll?(self, startIndex, endIndex)
        }
    }
}
