//
//  ViewController.swift
//  ControllerSliderDemo
//
//  Created by CoDancer on 2018/12/8.
//  Copyright © 2018年 IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dataArray = ["样式一","样式二"]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private lazy var tableView : UITableView = {
        () -> UITableView in
        
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        return tableView
    }()

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let vc = SliderViewController()
        vc.type = indexPath.row
        vc.title = dataArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



