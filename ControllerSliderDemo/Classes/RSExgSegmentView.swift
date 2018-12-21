//
//  RSExgSegmentView.swift
//  RSPointsMall
//
//  Created by CoDancer on 2018/10/30.
//  Copyright © 2018年 IOS. All rights reserved.
//

let SCREEN_WIDTH : CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let MAINSCREEN = UIScreen.main.bounds

import UIKit

typealias ActionBlock = (TypeModel) -> ()

class RSExgSegmentView: UIView {
    
    private lazy var selectTitleRGBlColor: (r : CGFloat, g : CGFloat, b : CGFloat) = getRGBWithColor(UIColor(r: 255, g: 0, b: 0))
    private lazy var titleRGBlColor: (r : CGFloat, g : CGFloat, b : CGFloat) = getRGBWithColor(UIColor(r: 0, g: 0, b: 0))  //文字的渐变颜色区间
    
    private var startOffsetX: CGFloat = 0.0
    private var scale: CGFloat = 1.5
    private var textWidths: [CGFloat] = []
    
    var selectedIdx: Int = 0  //被初始化选择的标题
    private var isClick = false
    private var currentIndex: Int = 0
    
    private var lrMargin: CGFloat = 10.0
    private var titleMargin: CGFloat = 30.0
    
    var labelWidth : CGFloat = 0       //不为0时，按钮为固定宽度布局
    
    var actionBlock : ActionBlock?
    
    var buttonArr = [UIButton]()

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        scrollView.frame = self.bounds
    }
    
    private lazy var scrollView : UIScrollView = {
        () -> UIScrollView in
        
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataModels: Array<TypeModel>! {
        
        willSet(newValue) {
            
            self.dataModels = newValue
        }
        
        didSet {
            
            for label in buttonArr {
                
                label.removeFromSuperview()
            }
            buttonArr.removeAll()
            setupButtonsLayout()
        }
    }
    
    private func setupButtonsLayout() {
        
        if dataModels.count == 0 { return }
        
        for obj in dataModels.enumerated() {
            
            if obj.element.typeName.count == 0 {
                
                textWidths.append(60)
                continue
            }
            
            let textW = obj.element.typeName.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 8),
                                                          options: .usesLineFragmentOrigin,
                                                          attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0)],
                                                          context: nil).size.width
            textWidths.append(textW)
        }
        
        // 按钮布局分 固定间隔布局 或是 固定宽度布局
        let flag = labelWidth == 0 ? true : false
        var upX: CGFloat = flag ? lrMargin : 0
        let titleOffW = flag ? titleMargin : 0
        let subH = bounds.height - 2
        
        for index in 0..<dataModels.count {
            
            let subW = flag ? textWidths[index] : labelWidth
            let buttonReact = CGRect(x: upX, y: 0, width: subW, height: subH)
            
            let button = subButton(frame: buttonReact, flag: index, title: dataModels[index].typeName, parentView: scrollView)
            let color = (index == selectedIdx ? UIColor.red : UIColor.black)
            button.setTitleColor(color, for: .normal)
            
            upX = button.frame.origin.x + subW + titleOffW
            buttonArr.append(button)
        }
        
        let scaleButton = buttonArr[selectedIdx]
        scaleButton.transform = CGAffineTransform(scaleX: scale , y: scale)
        
        let sliderContenSizeW = flag ? upX - titleMargin + lrMargin : upX
        
        if sliderContenSizeW < bounds.width {
            
            scrollView.frame.size.width = sliderContenSizeW
        }
        
        scrollView.contentSize = CGSize(width: sliderContenSizeW, height: 0)
    }
    
    private func subButton(frame: CGRect, flag: Int, title: String?, parentView: UIView) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.frame = frame
        button.tag = flag
        button.setTitle(title, for: .normal)
        
        let fontNum : CGFloat = labelWidth == 0 ? 15 : 14
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontNum)
        parentView.addSubview(button)
        
        button.addTarget(self, action: #selector(viewBtnDidTouch(sender:)), for: .touchUpInside)
        return button
    }
    
    @objc func viewBtnDidTouch(sender: UIButton) {
    
        self.isClick = true
        self.selectedIdx = sender.tag
        if actionBlock != nil {
            
            actionBlock!(self.dataModels[sender.tag])
        }
    }
    
    private func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        
        guard let components = color.cgColor.components else {
            
            fatalError("请使用RGB方式给标题颜色赋值")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
    
    private func scrollViewDidScrollOffsetX(_ offsetX: CGFloat)  {
        
        buttonStateChangeOffsetX(offsetX)
        
        if currentIndex != selectedIdx {
            
            setupSlierScrollToCenter(offsetX: offsetX, index: selectedIdx)
            
            if isClick {
                
                let upButton = buttonArr[currentIndex]
                let currentButton = buttonArr[selectedIdx]
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    currentButton.transform = CGAffineTransform(scaleX: self.scale , y: self.scale)
                    upButton.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0 )
                })
                
                setupButtonStatusAnimation(upButton: upButton, currentButton: currentButton)
                
            }
            
            currentIndex = selectedIdx
        }
        
        isClick = false
    }
    
    private func setupButtonStatusAnimation(upButton: UIButton, currentButton: UIButton)  {
        
        upButton.setTitleColor(.black, for: .normal)
        currentButton.setTitleColor(.red, for: .normal)
    }
    
    private func setupSlierScrollToCenter(offsetX: CGFloat, index: Int)  {
        
        let currentButton = buttonArr[index]
        let btnCenterX = currentButton.center.x
        var scrollX = btnCenterX - scrollView.bounds.width * 0.5
        
        if scrollX < 0 {
            
            scrollX = 0
        }
        
        if scrollX > scrollView.contentSize.width - scrollView.bounds.width {
            
            scrollX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        scrollView.setContentOffset(CGPoint(x: scrollX, y: 0), animated: true)
    }
    
    private func buttonStateChangeOffsetX(_ offsetX: CGFloat) {
        
        if isClick {
            
            return
        }
        
        var offsetX = offsetX
        let scrollW = bounds.width
        let scrollContenSizeW: CGFloat = bounds.width * CGFloat(dataModels.count)
        
        if offsetX + scrollW >= scrollContenSizeW {
            
            offsetX = scrollContenSizeW - scrollW - 0.5
        }
        if offsetX <= 0 {
            
            offsetX = 0.5
        }
        
        var nextIndex = Int(offsetX / scrollW)
        var sourceIndex = Int(offsetX / scrollW)
        //向下取整 目的是减去整数位，只保留小数部分
        var progress = (offsetX / scrollW) - floor(offsetX / scrollW)
        
        if offsetX > startOffsetX { // 向左滑动
            //向左滑动 下个位置比源位置下标 多1
            nextIndex = nextIndex + 1
        }else { // 向右滑动
            //向右滑动 由于源向下取整的缘故 必须补1 nextIndex则恰巧是原始位置
            sourceIndex = sourceIndex + 1
            progress = 1 - progress
        }
        
        let nextButton = buttonArr[nextIndex]
        let currentButton = buttonArr[sourceIndex]
        
        let colorDelta = (selectTitleRGBlColor.0 - titleRGBlColor.0, selectTitleRGBlColor.1 - titleRGBlColor.1, selectTitleRGBlColor.2 - titleRGBlColor.2)
        
        let nextColor = UIColor(r: titleRGBlColor.0 + colorDelta.0 * progress,
                                g: titleRGBlColor.1 + colorDelta.1 * progress,
                                b: titleRGBlColor.2 + colorDelta.2 * progress)
        
        let currentColor = UIColor(r: selectTitleRGBlColor.0 - colorDelta.0 * progress,
                                   g: selectTitleRGBlColor.1 - colorDelta.1 * progress,
                                   b: selectTitleRGBlColor.2 - colorDelta.2 * progress)
        
        currentButton.setTitleColor(currentColor, for: .normal)
        nextButton.setTitleColor(nextColor, for: .normal)
        
        let scaleDelta = (scale - 1.0) * progress
        currentButton.transform = CGAffineTransform(scaleX: scale - scaleDelta, y: scale - scaleDelta)
        nextButton.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
    }
    
    func titleScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func titleScrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollViewDidScrollOffsetX(scrollView.contentOffset.x)
    }

}
