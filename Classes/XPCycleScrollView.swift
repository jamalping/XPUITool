//
//  XPCycleScrollView.swift
//  XPUtilExample
//
//  Created by xyj on 2017/10/24.
//  Copyright © 2017年 xyj. All rights reserved.
//

import UIKit
import XPUtil

public class XPCycleScrollView: UIView {
    
    // 点击某个banner的事件监听: 将详情的标题和地址回传
//    var indexTap = Variable<(String?, String?)>.init((nil, nil))
    
    var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    var pageControl: UIPageControl = {
        
        let pageControl = UIPageControl()
        
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = UIColor.init(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 0.8)
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    
    
    /// MARK -- 定时器
    var animationTimer: Timer?
    
    /// MARK -- 自动滚动的时间间隔，若小于、等于0则不自动滚动
    var animationTimerInterval: TimeInterval = 3.0
    
    fileprivate var dataSource:[String]?
    
    public init(animationTimerInterval: TimeInterval = 5.0){
        super.init(frame: .zero)
        
        addSubview(scrollView)
        addSubview(pageControl)
        //        tap.addTarget(self, action: #selector(tapAction))
        scrollView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapAction)))
        
        scrollView.delegate = self
        self.animationTimerInterval = animationTimerInterval
        
        scrollView.frame = self.bounds
        
        pageControl.frame = CGRect.init(x: 0, y: self.frame.height - 20, width: self.frame.size.width, height: 10)
        
        if animationTimerInterval > 0 {
            
            animationTimer = Timer.scheduledTimer(timeInterval: animationTimerInterval, target: self, selector: #selector(animationTimerDidFire), userInfo: nil, repeats: true)
            
            animationTimer?.pauseTimer()
        }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setDataSource(_ datas: [String]) {
        self.dataSource = datas
        self.animationTimer?.resumeTimerAfterInterval(self.animationTimerInterval)
        var contentSize:CGSize? = CGSize.zero
        if datas.count > 1 {
            contentSize = CGSize(width: self.frame.size.width * CGFloat(datas.count+2), height: self.frame.size.height)

            scrollView.setContentOffset(CGPoint.init(x: self.frame.size.width, y: 0), animated: false)

            for i:Int in 0 ..< datas.count + 2 {
                var dataModel: String?
                if (i == 0) {
                    dataModel = datas[datas.count-1]
                }else if (i == datas.count + 1) {
                    dataModel = datas[0]
                }else{
                    dataModel = datas[i-1]
                }
//                let resource = ImageResource.init(downloadURL: URL.init(string: (bannerModel?.image_url)!)!)
                
                let imageView = UIImageView()
//                imageView.isUserInteractionEnabled = true
//                imageView.kf.setImage(with: resource)
//                imageView.backgroundColor = UIColor.
                scrollView.addSubview(imageView)
                imageView.frame = CGRect.init(x: scrollView.frame.width*CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
                
            }
        }else {
            contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        }

        self.scrollView.contentSize = contentSize!

        pageControl.numberOfPages = datas.count
    }
}


extension XPCycleScrollView: UIScrollViewDelegate {
    
    @objc func animationTimerDidFire() {
        let newOffset = CGPoint(x: self.scrollView.contentOffset.x + self.scrollView.frame.size.width, y: self.scrollView.contentOffset.y)
        self.scrollView.setContentOffset(newOffset, animated: true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < scrollView.frame.size.width {
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * CGFloat(self.dataSource!.count + 1), y: 0), animated: false)
        }
        if (scrollView.contentOffset.x > scrollView.frame.size.width * CGFloat(self.dataSource!.count + 1)) {
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width, y: 0), animated: false)
        }
        var pageCount = Int(scrollView.contentOffset.x / self.frame.size.width)
        if (pageCount > self.dataSource!.count) {
            pageCount = 0;
        }else if (pageCount == 0){
            pageCount = self.dataSource!.count - 1;
        }else{
            pageCount -= 1
        }
        self.pageControl.currentPage = pageCount;
        
        
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.animationTimer?.pauseTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.animationTimer?.resumeTimerAfterInterval(self.animationTimerInterval)
    }
    
    @objc
    public func tapAction() {
        if dataSource != nil && dataSource!.count > 0 {
            let bannerModel = self.dataSource![self.pageControl.currentPage]
            
            
//            indexTap.value = (title:bannerModel.image_title,title:bannerModel.image_detail_url)
        }
    }
    
}

