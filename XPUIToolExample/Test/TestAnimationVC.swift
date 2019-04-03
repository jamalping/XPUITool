//
//  TestAnimationVC.swift
//  XPUIToolExample
//
//  Created by Apple on 2018/12/15.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

class TestAnimationVC: UIViewController, ParticleAnimationable {
    enum AnimationType: String {
        case Emitter = "粒子动画-图片数组"
        case lineEmitter = "自定义粒子动画 - 线性"
        case lineBurstEmitter = "自定义粒子动画 - 线性 - 爆炸效果"
        case radiate = "向四周扩散动画"
    }
    var dataSource: [AnimationType] = [.Emitter, .lineEmitter, .lineBurstEmitter, .radiate]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        title = "animation"
        view.backgroundColor = .white
    }
}

extension TestAnimationVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = self.dataSource[indexPath.row].rawValue
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(self.dataSource[indexPath.row].rawValue)
        switch self.dataSource[indexPath.row] {
        case .Emitter:
            
            startParticleAnimation(CGPoint.init(x: self.view.width/2, y: view.height))
        case .lineEmitter:
            
            let emitterLayer = particleAnimation()
            let rockt = rocktParticleAnimation()
            emitterLayer.emitterCells = [rockt]
            
            self.showCustomParticle(emitter: emitterLayer)
            
        case .lineBurstEmitter:
            let emitterLayer = particleAnimation()
            let rockt = rocktParticleAnimation()
            let burst = burstParticleAnimation()
            let spark = sparkParticleAnimation()
            emitterLayer.emitterCells = [rockt]
            rockt.emitterCells = [burst]
            burst.emitterCells = [spark]
            self.showCustomParticle(emitter: emitterLayer)
        case .radiate:
            self.navigationController?.pushViewController(AnimationVC1(), animated: true)
        default: break
            
        }
    }
}

