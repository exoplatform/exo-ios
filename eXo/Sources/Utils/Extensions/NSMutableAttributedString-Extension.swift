//
//  NSMutableAttributedString-Extension.swift
//  eXo
//
//  Created by eXo Development on 17/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func append(text:String,color:UIColor,font:UIFont){
        let attributeText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.font:font])
        self.append(attributeText)
    }
}
