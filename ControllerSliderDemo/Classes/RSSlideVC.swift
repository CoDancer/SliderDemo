//
//  RSExchangeSlideVC.swift
//  RSPointsMall
//
//  Created by CoDancer on 2018/10/30.
//  Copyright © 2018年 IOS. All rights reserved.
//  一个界面中包含多个控制器类型，需继承

import UIKit

class RSSlideVC: UIViewController {
    
    var idx : Int = 0  //对外设置的下标

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        // 此处设置sub 中的view的高度
        contentScrollView.size = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 50 - 64)
        contentScrollView.topY = 50 + 64
    }
    
    lazy var contentScrollView : UIScrollView = {
        () -> UIScrollView in
        
        let _scrollView = UIScrollView()
        _scrollView.backgroundColor = .clear
        _scrollView.layer.masksToBounds = true
        return _scrollView
    }()
    
    lazy var segmentView : RSExgSegmentView = {  //标签视图
        () -> RSExgSegmentView in
        
        let view = RSExgSegmentView()
        view.selectedIdx = idx
        view.size = CGSize.init(width: SCREEN_WIDTH, height: 50)
        view.actionBlock = { [weak self] (value) in
            
            self?.btnDidTouchOfModel(model: value)
        }
        return view
    }()
    
    func configView() {
        
        removeViewOrVC()
        addChildViewController()
        setScollViewContent()
        setUpOneChildController(idx: idx)
    }
    
    func removeViewOrVC() {
        
        for obj in contentScrollView.subviews.enumerated() {
            obj.element.removeFromSuperview()
        }
        
        for obj in self.childViewControllers.enumerated() {
            obj.element.removeFromParentViewController()
        }
    }
    
    func addChildViewController() {}
    
    func setScollViewContent() {
        
        contentScrollView.contentSize = CGSize.init(width: CGFloat(segmentView.dataModels.count)*SCREEN_WIDTH, height: 0)
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.delegate = self
        
        contentScrollView.contentOffset = CGPoint.init(x: CGFloat(idx)*SCREEN_WIDTH, y: 0)
    }
    
    func setUpOneChildController(idx: Int) {
        
        let x : CGFloat = CGFloat(idx * Int(SCREEN_WIDTH))
        let vc : UIViewController = self.childViewControllers[idx]
        if vc.view.superview != nil {
            return
        }
        
        vc.view.frame = CGRect.init(x: x, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        contentScrollView.addSubview(vc.view)
    }
    
    func btnDidTouchOfModel(model: TypeModel) {
        
        let x: CGFloat = CGFloat(model.index) * SCREEN_WIDTH
        contentScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: false)
        
        setUpOneChildController(idx: model.index)
    }
    
    var typeModels: Array<TypeModel>! {
        
        willSet(newValue) {
            
            self.typeModels = newValue
        }
        
        didSet {
            
            segmentView.dataModels = typeModels
            
            configView()
            self.view.addSubview(contentScrollView)
        }
    }
        
    public func nextIndex() -> Int {
        
        if contentScrollView.bounds.width == 0 || contentScrollView.bounds.height == 0 {
            return 0
        }
        let index = Int((contentScrollView.contentOffset.x + contentScrollView.bounds.width * 0.5) / contentScrollView.bounds.width)
        return max(0, index)
    }

}

extension RSSlideVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let idx: Int = Int(contentScrollView.contentOffset.x / SCREEN_WIDTH)
        setUpOneChildController(idx: idx)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        segmentView.selectedIdx = nextIndex()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        segmentView.titleScrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        segmentView.titleScrollViewWillBeginDragging(scrollView)
    }
}


