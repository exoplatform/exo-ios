//
//  UIView-Extension.swift
//  eXo
//
//  Created by eXo Development on 14/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func makeCircular(){
        self.layer.cornerRadius = self.bounds.size.width/2
    }

    func makeShadowWith(offset:CGSize,radius:CGFloat,opacity:Float,color:UIColor){
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
    }

    func addCornerRadiusWith(radius:CGFloat){
        self.layer.cornerRadius = radius
    }

    func addBorderWith(width:CGFloat,color:UIColor){
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}

