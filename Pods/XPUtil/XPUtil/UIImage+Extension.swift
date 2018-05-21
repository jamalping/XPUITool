//
//  UIImage+Extension.swift
//  Ecredit
//
//  Created by xyj on 2017/7/4.
//  Copyright © 2017年 xyjw. All rights reserved.
//

import UIKit
import ImageIO
import CoreGraphics

extension UIImage {
    
    /// 获取图片的大小，多少bytes
    var bytesSize: Int { return UIImageJPEGRepresentation(self, 1)?.count ?? 0 }
    /// 获取图片的大小，多少kb
    var kiloBytesSize: Int {
        return self.bytesSize/1024
    }
    
    convenience init(color: UIColor) {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
    
    /// 是否有AlPha通道
    var hasAlphaChannnel: Bool {
        get {
            let alpha = self.cgImage?.alphaInfo
            return alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast
        }
    }
    
    // base64字符串转image
    convenience init?(base64ImgString: String) {
        let imageString = base64ImgString as NSString
        
        let dataString = imageString.replacingOccurrences(of:" ", with:"")
        
        let dataString1 = dataString.replacingOccurrences(of:"\n", with:"")
        
        let imageData = NSData(base64Encoded: dataString1, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        
        guard let data = imageData else { return nil }
        
        self.init(data: data as Data)
    }
    
    // image转base64字符串
    var toBase64String: String? {
        get {
            
            ///根据图片得到对应的二进制编码
            guard let imageData = UIImageJPEGRepresentation(self, 0.25) else {
                return nil
            }
            ///根据二进制编码得到对应的base64字符串
            let base64String = imageData.base64EncodedString(options: .lineLength76Characters)
            return base64String
        }
    }
    
    var toBase64StringPNG: String? {
        get {
            ///根据图片得到对应的二进制编码
            guard let imageData = UIImagePNGRepresentation(self) else {
                return nil
            }
            ///根据二进制编码得到对应的base64字符串
            let base64String = imageData.base64EncodedString(options: .lineLength76Characters)
            return base64String
        }
        
    }
    
    /// 转换成Data
    var toImageJPEGData: Data? {
        get {
            guard let imageData = UIImageJPEGRepresentation(self, 0.25) else { return nil }
            return imageData
        }
    }
    
    var toImagePNGData: Data? {
        get {
            guard let imageData = UIImagePNGRepresentation(self) else { return nil }
            return imageData
            
        }
    }
    
    
    /// 压缩图片
    ///
    /// - Parameters:
    ///   - maxLength: 最大长度
    /// - Returns:
    func compressImage(maxLength: Int) -> Data? {
        
        guard let vData = UIImageJPEGRepresentation(self, 1) else { return nil }
        
        if vData.count < maxLength {
            return vData
        }
        
        let newSize = self.scaleImages(self, imageLength: 1000)
        guard let newImage = self.resizeImage(self, newSize: newSize) else { return nil }
        
        var compress:CGFloat = 0.9
        guard var data = UIImageJPEGRepresentation(newImage, compress) else { return nil }
        
        while data.count > maxLength && compress > 0.01 {
            compress -= 0.02
            data = UIImageJPEGRepresentation(newImage, compress)!
        }
        return data
    }
    
    func  scaleImages(_ image: UIImage, imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func resizeImage(_ image: UIImage, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        
        image.draw(in:CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    // 加载本地gif
    static func imageWithGifName(name: String) -> UIImage? {
    
        var animatedImage: UIImage?
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else { return nil }
        guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else { return nil }
        let sources = CGImageSourceCreateWithData(data as CFData, nil)
        guard let source = sources else {
            return nil
        }
        let count =   CGImageSourceGetCount(source)
        
        if (count <= 1) {
            animatedImage = UIImage.init(data: data)
        } else {
            var images = [UIImage]()
            for i in 0..<count {
                if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage.init(cgImage: image, scale: UIScreen.main.scale, orientation: UIImageOrientation.up))
                }
            }
            animatedImage = UIImage.animatedImage(with: images, duration: Double(count)*0.1)
        }
     
        return animatedImage;
    }
        
    /// 获取某个点的UIColor
    ///
    /// - Parameter point: 目标点
    /// - Returns: UIColor
    func colorOfPoint(point: CGPoint)-> UIColor? {
        guard point.x >= 0 && point.y >= 0 else { return nil }
        guard let cgimage = self.cgImage else { return nil }
        let width = CGFloat(cgimage.width)
        let height = CGFloat(cgimage.height)
        guard point.x <= width && point.y <= height else { return nil }
        let pixelData = CGDataProvider.init(data: self.cgImage! as! CFData)

        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData as! CFData)
        let pixelInfo: Int = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
}
