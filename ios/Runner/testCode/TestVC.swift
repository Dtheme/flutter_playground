//
//  TestVC.swift
//  Runner
//
//  Created by dzw on 2023/12/14.
//

import UIKit
import Flutter

class TestVC: UIViewController {
    var text = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "原生页面"
        self.view.backgroundColor = UIColor.orange
        var lb = UILabel(frame: CGRect(x: 0, y: 100, width: 300, height: 44))
        lb.text = self.text
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(lb)
        
        var button = UIButton(frame: CGRect(x: self.view.center.x-100, y: UIScreen.main.bounds.size.height-100, width: 200, height: 44))
        button.setTitle("返回flutter页面", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1;
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(backFlutter), for: .touchUpInside)
        self.view.addSubview(button)
        
    }
    @objc func backFlutter() -> Void {
        self.dismiss(animated: true)
    }
}
