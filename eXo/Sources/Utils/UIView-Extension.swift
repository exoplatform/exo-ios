//
//  UIView-Extension.swift
//  eXo
//
//  Created by eXo Development on 11/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

extension UIView {
    // Make any view circular.
    func makeCircular(){
        self.layer.cornerRadius = self.bounds.size.width/2
    }
    // Add shadow to view.
    func makeShadowWith(offset:CGSize,radius:CGFloat,opacity:Float,color:UIColor){
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
    }
    // Add corner to view.
    func addCornerRadiusWith(radius:CGFloat){
        self.layer.cornerRadius = radius
    }
    // Add border to view.
    func addBorderWith(width:CGFloat,color:UIColor){
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
