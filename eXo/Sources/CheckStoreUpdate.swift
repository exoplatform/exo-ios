//
//  CheckStoreUpdate.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 2/2/2022.
//  Copyright © 2022 eXo. All rights reserved.
//

import Foundation

class CheckStoreUpdate {
    
    public static let shared = CheckStoreUpdate()
    var newVersionAvailable: Bool?
    var appStoreVersion: String?
    
    func checkAppStore(callback: ((_ versionAvailable: Bool, _ version: String?)->Void)? = nil) {
        var isNew: Bool = false
        var versionStr: String = ""
        let request = checkVersionRequest()
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error  {
                print(error)
            }
            
            if let dataa = data {
                let jsonn = try? JSONSerialization.jsonObject(with: dataa, options: [])
                if let json = jsonn as? NSDictionary,let results = json["results"] as? NSArray,let entry = results.firstObject as? NSDictionary,let appVersion = entry["version"] as? String,let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    isNew = ourVersion.compare(appVersion, options: .numeric) == .orderedAscending
                    versionStr = appVersion
                }
                self.appStoreVersion = versionStr
                self.newVersionAvailable = isNew
                DispatchQueue.main.async {
                    callback?(isNew, versionStr)
                }
            }
        })
        dataTask.resume()
    }
    
    /// Create the request .

    func checkVersionRequest() -> NSMutableURLRequest {
        let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let postData = NSMutableData(data: "undefined=undefined".data(using: String.Encoding.utf8)!)
        let request = NSMutableURLRequest(url: NSURL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        return request
    }
}
