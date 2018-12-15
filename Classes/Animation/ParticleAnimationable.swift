//
//  ParticleAnimationable.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/15.
//  Copyright © 2018年 worldunion. All rights reserved.
//
import UIKit


/// 粒子动画效果
protocol ParticleAnimationable {
    
}

extension ParticleAnimationable where Self : UIViewController {
    func startParticleAnimation(_ point : CGPoint) {
        // 1.创建发射器
        let emitter = CAEmitterLayer()
        
        // 2.设置发射器的位置
        emitter.emitterPosition = point
        
        // 3.开启三维效果
        emitter.preservesDepth = true
        
        // 4.创建例子, 并且设置例子相关的属性
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            // 4.1.创建例子Cell
            let cell = CAEmitterCell()
            
            // 4.2.设置粒子速度
            cell.velocity = 150
            cell.velocityRange = 100
            
            // 4.3.设置例子的大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            // 4.4.设置粒子方向
            cell.emissionLongitude = CGFloat(-Double.pi/2)
            cell.emissionRange = CGFloat(Double.pi/2 / 6)
            
            // 4.5.设置例子的存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            
            // 4.6.设置粒子旋转
            cell.spin = CGFloat(Double.pi/2)
            cell.spinRange = CGFloat(Double.pi/2 / 2)
            
            // 4.6.设置例子每秒弹出的个数
            cell.birthRate = 2
            
            // 4.7.设置粒子展示的图片
            cell.contents = UIImage(named: "good\(i)_30x30_@2x")?.cgImage
            
            // 4.8.添加到数组中
            cells.append(cell)
        }
        
        // 5.将粒子设置到发射器中
        emitter.emitterCells = cells
        // 先移除
        stopParticleAnimation()
        // 6.将发射器的layer添加到父layer中
        view.layer.addSublayer(emitter)
    }
    
    /// 粒子动画图层
    func particleAnimation() -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        let viewBounds = self.view.bounds
        // 设置发射位置
        emitter.emitterPosition = CGPoint.init(x: viewBounds.width/2, y: viewBounds.height)
        // 发射器大小
        emitter.emitterSize = CGSize.init(width: viewBounds.width/2, height: 0.0)
        // 发射模式
        emitter.emitterMode = kCAEmitterLayerOutline
        // 发射器形状
        emitter.emitterShape = kCAEmitterLayerLine
        // 叠加显示
        emitter.renderMode = kCAEmitterLayerAdditive
        
        emitter.seed = arc4random()%100+1
        
        return emitter
    }
    /// rocket 发射效果（线性）
    func rocktParticleAnimation() -> CAEmitterCell {
        let rocket = CAEmitterCell()
        // 出生率：每秒产生cell的数量
        rocket.birthRate = 2
        // 发射角度
        rocket.emissionRange = CGFloat.pi/9.0
        // 速度
        rocket.velocity = 380
        // y方向加速度分量
        rocket.yAcceleration = 100
        // 生命周期（存在的时间）
        rocket.lifetime = 1.02
        // 设置动画图片
        rocket.contents = UIImage.init(named: "talk_gift")?.cgImage
        // 缩放比例
        rocket.scale = 0.2
        
        // 粒子在rgb三个色想上的容差和透明度的容差
        rocket.greenRange = 1.0
        rocket.redRange = 1.0
        rocket.blueRange = 1.0
        // 自旋速度
        rocket.spinRange = CGFloat.pi
        
        return rocket
    }
    
    /// 破裂效果
    func burstParticleAnimation() -> CAEmitterCell {
        let burst = CAEmitterCell()
        burst.birthRate = 1.0
        burst.velocity = 0
        burst.scale = 2.5
        burst.redSpeed = -1.5
        burst.blueSpeed = 1.5
        burst.greenSpeed = 1.0
        burst.lifetime = 0.35
        
        return burst
    }
    
    /// 爆炸效果
    func sparkParticleAnimation() -> CAEmitterCell {
        let spark = CAEmitterCell()
        spark.birthRate = 50
        spark.velocity = 125
        spark.emissionRange = 2.0*CGFloat.pi
        spark.yAcceleration = 75
        spark.scale = 1.5
        spark.scaleSpeed = -0.2
        spark.redSpeed = -0.1
        spark.blueSpeed = 0.4
        spark.greenSpeed = -0.5
        spark.lifetime = 3
        spark.contents = UIImage.init(named: "talk_gift")?.cgImage
        spark.spin = 2.0*CGFloat.pi
        spark.spinRange = 2.0*CGFloat.pi
        
        return spark
    }
    /// 将粒子动画图层加到目标图层上
    func showCustomParticle(emitter: CAEmitterLayer) {
        
        /// 加上前，先把所有的粒子动画的layer层移除
        stopParticleAnimation()
        
        view.layer.addSublayer(emitter)
    }
    /// 移除粒子动画图层
    func stopParticleAnimation() {
       
        view.layer.sublayers?.filter{ $0.isKind(of: CAEmitterLayer.self)}.forEach{ $0.removeFromSuperlayer() }
    }
}

extension ParticleAnimationable where Self : UIView {
    func startParticleAnimation(_ point : CGPoint) {
        // 1.创建发射器
        let emitter = CAEmitterLayer()
        
        // 2.设置发射器的位置
        emitter.emitterPosition = point
        
        // 3.开启三维效果
        emitter.preservesDepth = true
        
        // 4.创建例子, 并且设置例子相关的属性
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            // 4.1.创建例子Cell
            let cell = CAEmitterCell()
            
            // 4.2.设置粒子速度
            cell.velocity = 150
            cell.velocityRange = 100
            
            // 4.3.设置例子的大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            // 4.4.设置粒子方向
            cell.emissionLongitude = CGFloat(-Double.pi/2)
            cell.emissionRange = CGFloat(Double.pi/2 / 6)
            
            // 4.5.设置例子的存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            
            // 4.6.设置粒子旋转
            cell.spin = CGFloat(Double.pi/2)
            cell.spinRange = CGFloat(Double.pi/2 / 2)
            
            // 4.6.设置例子每秒弹出的个数
            cell.birthRate = 2
            
            // 4.7.设置粒子展示的图片
            cell.contents = UIImage(named: "good\(i)_30x30_@2x")?.cgImage
            
            // 4.8.添加到数组中
            cells.append(cell)
        }
        
        // 5.将粒子设置到发射器中
        emitter.emitterCells = cells
        // 先移除
        stopParticleAnimation()
        // 6.将发射器的layer添加到父layer中
        self.layer.addSublayer(emitter)
    }
    
    /// 粒子动画图层
    func particleAnimation() -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        let viewBounds = self.bounds
        // 设置发射位置
        emitter.emitterPosition = CGPoint.init(x: viewBounds.width/2, y: viewBounds.height)
        // 发射器大小
        emitter.emitterSize = CGSize.init(width: viewBounds.width/2, height: 0.0)
        // 发射模式
        emitter.emitterMode = kCAEmitterLayerOutline
        // 发射器形状
        emitter.emitterShape = kCAEmitterLayerLine
        // 叠加显示
        emitter.renderMode = kCAEmitterLayerAdditive
        
        emitter.seed = arc4random()%100+1
        
        return emitter
    }
    /// rocket 发射效果（线性）
    func rocktParticleAnimation() -> CAEmitterCell {
        let rocket = CAEmitterCell()
        // 出生率：每秒产生cell的数量
        rocket.birthRate = 2
        // 发射角度
        rocket.emissionRange = CGFloat.pi/9.0
        // 速度
        rocket.velocity = 380
        // y方向加速度分量
        rocket.yAcceleration = 100
        // 生命周期（存在的时间）
        rocket.lifetime = 1.02
        // 设置动画图片
        rocket.contents = UIImage.init(named: "talk_gift")?.cgImage
        // 缩放比例
        rocket.scale = 0.2
        
        // 粒子在rgb三个色想上的容差和透明度的容差
        rocket.greenRange = 1.0
        rocket.redRange = 1.0
        rocket.blueRange = 1.0
        // 自旋速度
        rocket.spinRange = CGFloat.pi
        
        return rocket
    }
    
    /// 破裂效果
    func burstParticleAnimation() -> CAEmitterCell {
        let burst = CAEmitterCell()
        burst.birthRate = 1.0
        burst.velocity = 0
        burst.scale = 2.5
        burst.redSpeed = -1.5
        burst.blueSpeed = 1.5
        burst.greenSpeed = 1.0
        burst.lifetime = 0.35
        
        return burst
    }
    
    /// 爆炸效果
    func sparkParticleAnimation() -> CAEmitterCell {
        let spark = CAEmitterCell()
        spark.birthRate = 50
        spark.velocity = 125
        spark.emissionRange = 2.0*CGFloat.pi
        spark.yAcceleration = 75
        spark.scale = 1.5
        spark.scaleSpeed = -0.2
        spark.redSpeed = -0.1
        spark.blueSpeed = 0.4
        spark.greenSpeed = -0.5
        spark.lifetime = 3
        spark.contents = UIImage.init(named: "talk_gift")?.cgImage
        spark.spin = 2.0*CGFloat.pi
        spark.spinRange = 2.0*CGFloat.pi
        
        return spark
    }
    /// 将粒子动画图层加到目标图层上
    func showCustomParticle(emitter: CAEmitterLayer) {
        
        /// 加上前，先把所有的粒子动画的layer层移除
        stopParticleAnimation()
        
        self.layer.addSublayer(emitter)
    }
    /// 移除粒子动画图层
    func stopParticleAnimation() {
        
        self.layer.sublayers?.filter{ $0.isKind(of: CAEmitterLayer.self)}.forEach{ $0.removeFromSuperlayer() }
    }
}

