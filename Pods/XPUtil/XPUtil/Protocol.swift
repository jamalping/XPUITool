//
//  CheckValueTool.swift
//  XPUtilExample
//
//  Created by xp on 2018/5/23.
//  Copyright © 2018年 xyj. All rights reserved.
//

import Foundation
import UIKit

// MARK: --- ImageFactory
public protocol ImageFactory {
    
    /// 颜色转image
    func createImage(color: UIColor) -> UIImage?
    
    /// gifData转image
    func gifImage(gifData: Data) -> UIImage?
}

// MARK: --- 实现 ImageFactory
public extension ImageFactory {
    public func createImage(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
    public func gifImage(gifData: Data) -> UIImage? {
        
        guard let sources = CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        
        let count =   CGImageSourceGetCount(sources)
        
        if (count <= 1) {
            return UIImage.init(data: gifData)
        } else {
            var images = [UIImage]()
            for i in 0..<count {
                if let image = CGImageSourceCreateImageAtIndex(sources, i, nil) {
                    images.append(UIImage.init(cgImage: image, scale: UIScreen.main.scale, orientation: UIImageOrientation.up))
                }
            }
            return UIImage.animatedImage(with: images, duration: Double(count)*0.1)
        }
    }
}
