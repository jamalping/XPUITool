//
//  TestTiledLayerVC.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/15.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class TestTiledLayerVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CATiledLayer的使用"
        
        view.backgroundColor = .white
       let largeImg = UIImage.init(named: "largeImage") ?? UIImage()
        let largeImage = LargeImageView.init(frame: CGRect.init(origin: CGPoint.zero, size: largeImg.size))
        largeImage.backgroundColor = .red
        
        let scrollView = UIScrollView.init(frame: self.view.bounds)
        
        scrollView.contentSize = largeImg.size
        scrollView.addSubview(largeImage)
        self.view.addSubview(scrollView)
    }
}



let kJCDefaultTileSize: CGFloat = 256.0

class LargeImageView: UIView {
    
    let largeImage: UIImage = UIImage.init(named: "largeImage") ?? UIImage()

    var tileSize: CGSize = CGSize(width: kJCDefaultTileSize, height: kJCDefaultTileSize) {
        didSet {
            let scaledTileSize = self.tileSize.applying(CGAffineTransform(scaleX: self.contentScaleFactor, y: self.contentScaleFactor))
            self.tiledLayer().tileSize = scaledTileSize
        }
    }
    
    var shouldAnnotateRect: Bool = false
    
    override class var layerClass : AnyClass {
        return XPTiledLayer.self
    }
    
    func tiledLayer() -> XPTiledLayer {
        return self.layer as! XPTiledLayer
    }
    
    var numberOfZoomLevels: size_t {
        get {
            return self.tiledLayer().levelsOfDetailBias
        }
        set {
            self.tiledLayer().levelsOfDetailBias = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let scaledTileSize = self.tileSize.applying(CGAffineTransform(scaleX: self.contentScaleFactor, y: self.contentScaleFactor))
        self.tiledLayer().tileSize = scaledTileSize
        self.tiledLayer().levelsOfDetail = 1
        self.numberOfZoomLevels = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let scale = ctx.ctm.a / tiledLayer().contentsScale
        
        let col = Int(rect.minX * scale / tileSize.width)
        let row = Int(rect.minY * scale / tileSize.height)

        let imgRect = CGRect.init(x: CGFloat(col)*tileSize.width, y: CGFloat(row)*tileSize.height, width: tileSize.width, height: tileSize.height)
        print(imgRect)
        //截取指定图片区域，重绘
        autoreleasepool { () -> () in
            let cgImg = largeImage.cgImage?.cropping(to: imgRect)
            let currentImg = UIImage.init(cgImage: cgImg!)
            let content = UIGraphicsGetCurrentContext()
            UIGraphicsPushContext(content!)
            currentImg.draw(in: imgRect)
            UIGraphicsPopContext()
        }
       
        if shouldAnnotateRect {
            annotateRect(rect, inContext: ctx)
        }
    }
    
    // Handy for Debug
    func annotateRect(_ rect: CGRect, inContext ctx: CGContext)
    {
        let scale = ctx.ctm.a / self.tiledLayer().contentsScale
        let lineWidth = 2.0 / scale
        let fontSize = 16.0 / scale
        
        UIColor.white.set()
        NSString.localizedStringWithFormat(" %0.0f", log2f(Float(scale))).draw(
            at: CGPoint(x: rect.minX, y: rect.minY),
            withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)]
        )
        
        UIColor.red.set()
        ctx.setLineWidth(lineWidth)
        ctx.stroke(rect)
    }
    
}

class XPTiledLayer: CATiledLayer
{
    let kDefaultFadeDuration: CFTimeInterval = 0.08
    
    var fadeDuration: CFTimeInterval
    {
        return kDefaultFadeDuration
    }
}
