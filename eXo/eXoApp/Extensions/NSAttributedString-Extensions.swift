//
//  File.swift
//  eXo
//
//  Created by eXo Development on 10/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString{
    
    class func returnText(data:[String:UIColor])->NSMutableAttributedString{
        let myAttrString = NSMutableAttributedString()
        for (key, value) in data{
            let myAttributeColor = [ NSAttributedString.Key.foregroundColor: value ]
            let attributeText = NSAttributedString(string: key, attributes: myAttributeColor)
            myAttrString.append(attributeText)
        }
        return myAttrString
    }
    
    func append(text:String,color:UIColor,font:UIFont){
        let attributeText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.font:font])
        self.append(attributeText)
    }
}
