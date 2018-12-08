//
//  TypeModel.swift
//  ControllerSliderDemo
//
//  Created by CoDancer on 2018/12/8.
//  Copyright © 2018年 IOS. All rights reserved.
//

import UIKit

class TypeModel: NSObject {

    var typeName = ""
    var isSelected = false
    var index = 0
    
    let dicArr1 = [["name":"标签一"],
                      ["name":"标签二"],
                      ["name":"标签三"]
    ]
    
    let dicArr2 = [["name":"标签一"],
                   ["name":"标签二"],
                   ["name":"标签三"],
                   ["name":"标签四"],
                   ["name":"标签五"],
                   ["name":"标签六"],
                   ["name":"标签七"]
    ]
    
    func typeModel(dic : [String : Any]) -> TypeModel {
        
        let model = TypeModel()
        model.typeName = dic["name"] as! String
        return model
    }
    
    func modelArr1(idx: NSInteger) -> [TypeModel] {
        
        var mutModel = [TypeModel]()
        
        var array = [[String: String]]()
        if idx == 0 {
            
            array = dicArr1
        }else if idx == 1 {
            
            array = dicArr2
        }
        
        for obj in array.enumerated() {
            
            let model = TypeModel().typeModel(dic: obj.element)
            model.index = obj.offset
            model.isSelected = obj.offset == 0 ? true : false
            mutModel.append(model)
        }
        
        return mutModel
    }

}
