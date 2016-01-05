//
//  PlaceholderTextView.swift
//
//  Created by CHEEBOW on 2015/07/24.
//  Copyright (c) 2015年 CHEEBOW. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {
    let PLACEHOLDER_LEFT_MARGIN: CGFloat = 4.0
    let PLACEHOLDER_TOP_MARGIN: CGFloat = 8.0
    
    var placeholderLabel: UILabel = UILabel()

    var _placeholderColor: UIColor = UIColor.lightGrayColor()
    var placeholderColor: UIColor {
        set {
            _placeholderColor = newValue
            self.placeholderLabel.textColor = self.placeholderColor
        }
        get {
            return _placeholderColor
        }
    }
    
    var _placeholder: String = ""
    var placeholder: String {
        set {
            _placeholder = newValue
            self.placeholderLabel.text = self.placeholder
            self.placeholderSizeToFit()
        }
        get {
            return _placeholder
        }
    }
    
    override var text: String! {
        set {
            super.text = newValue
            self.textChanged(nil)
        }
        get {
            return super.text
        }
    }

    override var font: UIFont! {
        set {
            super.font = newValue
            self.placeholderLabel.font = newValue
            self.placeholderSizeToFit()
        }
        get {
            return super.font
        }
    }
    
    private func placeholderSizeToFit() {
        self.placeholderLabel.frame = CGRectMake(PLACEHOLDER_LEFT_MARGIN, PLACEHOLDER_TOP_MARGIN, self.frame.width - PLACEHOLDER_LEFT_MARGIN * 2, 0.0)
        self.placeholderLabel.sizeToFit()
    }

    private func setup() {
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.font = UIFont.systemFontOfSize(16.0)
        
        self.placeholderLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.placeholderLabel.numberOfLines = 0
        self.placeholderLabel.font = self.font
        self.placeholderLabel.backgroundColor = UIColor.clearColor()
        self.placeholderLabel.alpha = 1.0
        self.placeholderLabel.tag = 999
        
        self.placeholderLabel.textColor = self.placeholderColor
        self.placeholderLabel.text = self.placeholder
        self.placeholderSizeToFit()
        self.addSubview(placeholderLabel)

        self.sendSubviewToBack(placeholderLabel)

        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "textChanged:", name: UITextViewTextDidChangeNotification, object: nil)
        
        self.textChanged(nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setup()
    }
    
    convenience init() {
        self.init(frame: CGRectZero, textContainer: nil)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }

    func textChanged(notification:NSNotification?) {
        self.viewWithTag(999)?.alpha = self.text.isEmpty ? 1.0 : 0.0
    }
}