//
//  APIManager.swift
//  eXo
//
//  Created by eXo Development on 21/04/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import Foundation

class APIManager: NSObject {
    static let sharedInstance = APIManager()
   
    func getActivities(username:String,password:String){
        let url = NSURL(string: "https://community.exoplatform.com/rest/private/v1/social/activities")
        let request = NSMutableURLRequest(url: url! as URL)
        let config = URLSessionConfiguration.default
        let userPasswordString = "\(username):\(password)"
        let userPasswordData = userPasswordString.data(using:String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            do {
                if let data = data {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(BaseActivityStreamResponse.self, from: data)
                    if let activitiesList = response.activities {
                        DataHelpr.sharedInstance.activitiesList = activitiesList
                    }
                    print(response)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
