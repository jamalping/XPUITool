//
//  ViewController.swift
//  XPUIToolExample
//
//  Created by xp on 2018/6/1.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

extension UIView {
    public func circleView(frame: CGRect? = nil) {
        print("yuan")
        let aFrame = frame ?? self.bounds
        let maskPath = UIBezierPath.init(roundedRect: aFrame, byRoundingCorners: .allCorners, cornerRadii: aFrame.size)
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

class ViewController: UIViewController {

    enum TestType: String {
        case translucentCircularButton = "translucentCircularButton"
        case slid = "slid"
        case titleTextFeil = "titleTextFeil"
    }
    let datasource: [TestType] = [.translucentCircularButton, .slid, .titleTextFeil]
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = self.datasource[indexPath.row].rawValue
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.datasource[indexPath.row] {
        case .translucentCircularButton:
            let vc = TestVC1()
            self.navigationController?.pushViewController(vc, animated: true)
        case .slid:
            let vc = XPSlideViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .titleTextFeil:
            let vc = TestVC1()
            self.navigationController?.pushViewController(vc, animated: true)
        default: break
            
        }
    }
}

