//
//  SliderViewController.swift
//  ControllerSliderDemo
//
//  Created by CoDancer on 2018/12/8.
//  Copyright © 2018年 IOS. All rights reserved.
//

import UIKit

class SliderViewController: RSSlideVC {
    
    var type: NSInteger = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        typeModels = TypeModel().modelArr1(idx: type)
    }
    
    override func loadView() {
        
        super.loadView()
        
        idx = 1
        
        if type == 0 {
            
            view.addSubview(segmentTypeView)
        }else {
            
            view.addSubview(segmentView)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if type == 0 {
            
            segmentTypeView.topY = 64
        }else {
            
            segmentView.size = CGSize.init(width: SCREEN_WIDTH, height: 50.0)
            segmentView.topY = 64
        }
        
    }
    
    override func addChildViewController() {
        
        for model in typeModels {
            
            let vc = SubSliderController()
            vc.typeModel = model
            self.addChildViewController(vc)
        }
    }

    private lazy var segmentTypeView: UIView = {
        () -> UIView in
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        view.addSubview(segmentView)
        segmentView.centerY = view.height/2.0
        segmentView.labelWidth = SCREEN_WIDTH/3.0   //title 的宽度
        
        let lineView = UIView()
        lineView.size = CGSize.init(width: SCREEN_WIDTH, height: 1.0)
        lineView.backgroundColor = UIColor.init(valueRGB: 0xDFE1E2)
        view.addSubview(lineView)
        lineView.bottomY = view.height
        
        view.backgroundColor = .white
        return view
    }()
}
