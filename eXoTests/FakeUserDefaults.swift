//  Copyright (c) 2014 Mark Grimes. All rights reserved.

import Foundation

class FakeUserDefaults : UserDefaults {
    
    typealias FakeDefaults = Dictionary<String, AnyObject?>
    var data : FakeDefaults
    
    init () {
        data = FakeDefaults()
        super.init(suiteName: "UnitTest")!
    }
    
    // NOP
    
    override func synchronize() -> Bool {
        return true
    }
    
    // Accessors
    
    override func object(forKey defaultName: String) -> Any? {
        return data[defaultName]!
    }
    
    override func value(forKey key: String) -> Any? {
        return data[key]!
    }
    
    override func bool(forKey defaultName: String) -> Bool {
        return data[defaultName] as! Bool
    }
    
    override func integer(forKey defaultName: String) -> Int {
        return data[defaultName] as! Int
    }
    
    override func float(forKey defaultName: String) -> Float {
        return data[defaultName] as! Float
    }
    
    // Mutators
    
    override func set(_ value: Any?, forKey defaultName: String) {
        data[defaultName] = value as AnyObject
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        data[key] = value as AnyObject
    }
    
    override func set(_ value: Bool, forKey defaultName: String) {
        data[defaultName] = value as Bool as AnyObject
    }
    
    override func set(_ value: Int, forKey defaultName: String) {
        data[defaultName] = value as Int as AnyObject
    }
    
    override func set(_ value: Float, forKey defaultName: String) {
        data[defaultName] = value as Float as AnyObject
    }
    
}

extension UserDefaults {
    
    @objc class func mockDefaults() -> FakeUserDefaults {
        return FakeUserDefaults()
    }
    
}
