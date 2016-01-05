//  Copyright (c) 2014 Mark Grimes. All rights reserved.

import Foundation

class FakeUserDefaults : NSUserDefaults {
    
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
    
    override func objectForKey(defaultName: String) -> AnyObject? {
        return data[defaultName]!
    }
    
    override func valueForKey(key: String) -> AnyObject? {
        return data[key]!
    }
    
    override func boolForKey(defaultName: String) -> Bool {
        return data[defaultName] as! Bool
    }
    
    override func integerForKey(defaultName: String) -> Int {
        return data[defaultName] as! Int
    }
    
    override func floatForKey(defaultName: String) -> Float {
        return data[defaultName] as! Float
    }
    
    // Mutators
    
    override func setObject(value: AnyObject?, forKey defaultName: String) {
        data[defaultName] = value
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        data[key] = value
    }
    
    override func setBool(value: Bool, forKey defaultName: String) {
        data[defaultName] = value as Bool
    }
    
    override func setInteger(value: Int, forKey defaultName: String) {
        data[defaultName] = value as Int
    }
    
    override func setFloat(value: Float, forKey defaultName: String) {
        data[defaultName] = value as Float
    }
    
}

extension NSUserDefaults {
    
    @objc class func mockDefaults() -> FakeUserDefaults {
        return FakeUserDefaults()
    }
    
}
