//
//  UIViewExtension.swift
//  eXo
//
//  Created by eXo Development on 10/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

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


extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
