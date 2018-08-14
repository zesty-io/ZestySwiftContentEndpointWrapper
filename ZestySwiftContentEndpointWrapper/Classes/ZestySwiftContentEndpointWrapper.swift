//
//  ZestySwiftContentEndpointWrapper.swift
//
//  Created by Ronak Shah on 7/16/18.
//  Copyright © 2018 Zesty.io. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


/// ZestySwiftContentEndpointWrapper is a wrapper class used to get data from your [Zesty.io](https://zesty.io) website.
///
/// Functions:
/// ==========
///
/// `init(url: String)`
///
/// `func getItem(for zuid: String, completionHandler: @escaping (_ data: [String : String]) -> Void)`
///
/// `func getArray(for zuid: String, completionHandler: @escaping (_ data: [[String : String]]) -> Void)`
///
/// `func getCustomData(from endpoint: String, params: [String : String]!, completionHandler: @escaping (_ data: JSON) -> Void)`
///
///
/// - author: [@ronakdev](https://github.ronakshah.net)
/// - copyright: 2018 Zesty.io
public class ZestySwiftContentEndpointWrapper {
    /// This is the baseURL that your zesty.io site is stored at. For example, "http://burger.zesty.site"
    public var baseURL: String
    
    /// Creates a `ZestySwiftContentEndpointWrapper` object for your website
    ///
    ///
    /// Sample Usage
    /// ==========
    ///
    /// Code
    /// ----
    ///
    /// For example, creating a ZestySwiftContentEndpointWrapper Object for your website `http://burger.zesty.site`
    ///
    ///     // Create the ZestySwiftContentEndpointWrapper Object
    ///     let zesty ZestySwiftContentEndpointWrapper(url: "http://burger.zesty.site")
    ///
    /// - note: If your website does not have an SSL Certificate (HTTPS), you will need to configure your app to allow for non HTTPS Calls. [How to change this setting](https://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http)
    /// - parameters:
    ///   - url: Your [Zesty.io](https://zesty.io) website
    public init(url: String) {
        self.baseURL = url
    }
    
    /// Gets a Data object for the endpoint and parameters specified. If you are retrieving JSON data, we recommend using getCustomJSONData instead. This method is intended to be used for all non JSON Data
    ///
    /// The endpoint is the name of the file that you created in Zesty
    ///
    /// A full tutorial to create your own custom JSON Endpoints can be found [here](https://developer.zesty.io/docs/code-editor/customizable-json-endpoints-for-content/)
    ///
    /// Sample Usage
    /// ==========
    ///
    /// Using the custom endpoint `/-/custom/event.ics`
    ///
    /// Code
    /// ----
    ///
    ///     // Create the ZestySwiftContentEndpointWrapper Object
    ///     let zesty ZestySwiftContentEndpointWrapper(url: "http://burger.zesty.site")
    ///     let endpoint = "/-/custom/event.ics"
    ///     let parameters = ["id" : "7-6a0c3ae-dz5cmr"]
    ///     getCustomData(from: endpoint, params: parameters, { (data, error) in
    ///         if (error != nil) {
    ///             // error handling
    ///             return
    ///         }
    ///         print(data) // data is a Data object. For more information on what the Data object does, [see Apple's documentation](https://developer.apple.com/documentation/foundation/data)
    ///     }
    /// - note: ZestySwiftContentEndpointWrapper uses [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) to handle JSON objects. The returned JSON object's methods reference can be found [here](https://github.com/SwiftyJSON/SwiftyJSON#usage). If you want to use a different type of JSON parsing, the raw data can be extracted from the JSON object using `json.rawString(options: [.castNilToNSNull: true])`. More information on extracting the raw JSON String can be found [here](https://github.com/SwiftyJSON/SwiftyJSON#user-content-string-representation)
    /// - parameters:
    ///   - endpoint: The endpoint string you are using.
    ///   - params: A Dictionary containing all the parameters. Use `nil` if there are no parameters
    ///   - completionHandler: Closure that handles the data once it is retrieved. If nothing is found, an empty Data object will be returned instead, and the error will be printed to the console.
    ///   - data: Returned through the closure, this is the [Data](https://developer.apple.com/documentation/foundation/data) object
    public func getCustomData(from endpoint: String, params: [String : String]!, completionHandler: @escaping (_ data: Data, _ error: ZestyError?) -> Void) {
        var paramText = ""
        if (params != nil) {
            paramText = "?"
            paramText += params.map({ (key, value) -> String in
                return "\(key)=\(value)&"
            }).reduce("",+)
        }
        
        let urlString = "\(self.baseURL)/\(endpoint)\(paramText)"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        Alamofire.request(url, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
                break
            case .failure(let error):
                print("ERROR DUE TO ALAMOFIRE\n\nERROR DESCRIPTION: ")
                print(error.localizedDescription)
                print("\n\nEND ERROR DESCRIPTION")
                completionHandler(Data(), ZestyError.alamofireError)
                break
            }
        }
    }
    /// Gets a UIImage for the url specified.
    /// The url is any url that gives you an image in a compatible format (as specified by UIImage)
    ///
    ///
    /// To get the url for an image zuid in Zesty, you will need to create an image endpoint
    ///
    /// image endpoint file
    ///
    ///     {
    ///         {{ if {get_var.id} }}
    ///             "url" : "{{ get_var.id.getImage()}}"
    ///         {{ end-if}}
    ///     }
    ///
    ///
    /// You can then use getCustomJSONData in combination with getImage to get the UIImage you require
    ///
    /// Sample Usage
    /// ==========
    ///
    /// After getting the image zuid 3-6a1c0cb-cgo7w from another data call, we use getCustomJSONData and getImage to retrieve our data
    ///
    /// Code
    /// ----
    ///
    ///     // Create the ZestySwiftContentEndpointWrapper Object
    ///     let zesty ZestySwiftContentEndpointWrapper(url: "http://burger.zesty.site")
    ///     let endpoint = "image" // created to look as the above code details
    ///     let parameters = ["id" : "3-6a1c0cb-cgo7w"]
    ///     zesty.getCustomJSONData(from: endpoint, params: parameters { (json, error) in
    ///         if (error != nil) {
    ///             // error handling
    ///             return
    ///         }
    ///         let imageURLString = json["url"].stringValue
    ///         zesty.getImage(imageURLString) { (image, error) in
    //              if error != nil {
    //                  imageView.image = image // image is now a UIImage object
    //              }
    //          }
    ///     }
    /// - note: ZestySwiftContentEndpointWrapper uses [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) to handle JSON objects. The returned JSON object's methods reference can be found [here](https://github.com/SwiftyJSON/SwiftyJSON#usage). If you want to use a different type of JSON parsing, the raw data can be extracted from the JSON object using `json.rawString(options: [.castNilToNSNull: true])`. More information on extracting the raw JSON String can be found [here](https://github.com/SwiftyJSON/SwiftyJSON#user-content-string-representation)
    /// - parameters:
    ///   - urlString: The url string where your image is located at. You can get this string in a variety of ways. The url does not need to belong to your zesty.io site, but it must be served over HTTPS unless your App Transport Security Settings allow otherwise.
    ///   - completionHandler: Closure that handles the data once it is retrieved. If nothing is found, nil be returned instead, and the error will be printed to the console.
    ///   - image: returned through the closure, this will be nil if error != nil. Otherwise, it will be a UIImage downloaded from the internet
    public func getImage(for urlString: String, completionHandler: @escaping (_ image: UIImage?, _ error: ZestyError?) -> Void) {
        var error: ZestyError? = nil
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    completionHandler(image, error)
                    return
                }
                else {
                    error = ZestyError.incorrectShape
                }
            }
            else {
                error = ZestyError.noData
            }
        }
        else {
            error = ZestyError.invalidURL
        }
        completionHandler(nil, error)
    }
    
    /// Gets a [JSON](https://github.com/SwiftyJSON/SwiftyJSON#usage) object for the endpoint and parameters specified
    ///
    /// The endpoint is the name of the file that you created in Zesty
    ///
    /// A full tutorial to create your own custom JSON Endpoints can be found [here](https://developer.zesty.io/docs/code-editor/customizable-json-endpoints-for-content/)
    ///
    /// Sample Usage
    /// ==========
    ///
    /// Using the custom endpoint `/-/custom/menulist.json`
    ///
    /// Code
    /// ----
    ///
    ///     // Create the ZestySwiftContentEndpointWrapper Object
    ///     let zesty ZestySwiftContentEndpointWrapper(url: "http://burger.zesty.site")
    ///     let endpoint = "/-/custom/menulist.json"
    ///     let parameters = ["location" : "San Diego"]
    ///     getCustomData(from: endpoint, params: parameters, { (json, error) in
    ///         if (error != nil) {
    ///             // error handling
    ///             return
    ///         }
    ///         print(item) // item is a [String : String] dictionary, in JSON Format
    ///     }
    /// - note: ZestySwiftContentEndpointWrapper uses [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) to handle JSON objects. The returned JSON object's methods reference can be found [here](https://github.com/SwiftyJSON/SwiftyJSON#usage). If you want to use a different type of JSON parsing, the raw data can be extracted from the JSON object using `json.rawString(options: [.castNilToNSNull: true])`. More information on extracting the raw JSON String can be found [here](https://github.com/SwiftyJSON/SwiftyJSON#user-content-string-representation)
    /// - parameters:
    ///   - endpoint: The endpoint string you are using.
    ///   - params: A Dictionary containing all the parameters. Use `nil` if there are no parameters
    ///   - completionHandler: Closure that handles the data once it is retrieved. If nothing is found, an empty array will be returned instead, and the error will be printed to the console.
    ///   - data: Returned through the closure, this is the [JSON](https://github.com/SwiftyJSON/SwiftyJSON#usage) object
    public func getCustomJSONData(from endpoint: String, params: [String : String]!, completionHandler: @escaping (_ data: JSON, _ error: ZestyError?) -> Void) {
        var paramText = ""
        if (params != nil) {
            paramText = "?"
            paramText += params.map({ (key, value) -> String in
                return "\(key)=\(value)&"
            }).reduce("",+)
        }
        
        let urlString = "\(self.baseURL)/\(endpoint)\(paramText)"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json, nil)
            case .failure(let error):
                print("ERROR DUE TO ALAMOFIRE\n\nERROR DESCRIPTION: ")
                print(error.localizedDescription)
                print("\n\nEND ERROR DESCRIPTION")
                completionHandler(JSON.null, ZestyError.alamofireError)
            }
        }
    }
    
    /// Gets a `[String : String]` json data for the specific zuid.
    ///
    /// You can find the zuid by looking at the *Content* Tab of Zesty.
    ///
    /// Zuid Meanings and Functions to Use
    ///
    /// - Any zuid that starts with a **6** is an array of items (use `getArray`)
    /// - Any zuid that starts with a **7** is an object (use `getItem`)
    ///
    /// Sample Usage
    /// ==========
    ///
    /// Code
    /// ----
    ///
    /// For example, getting a specific item with zuid `6-9bfe5c-ntqxrs`
    ///
    ///     // Create the ZestySwiftContentEndpointWrapper Object
    ///     let zesty ZestySwiftContentEndpointWrapper(url: "http://burger.zesty.site")
    ///     let zuid = "6-9bfe5c-ntqxrs"
    ///
    ///     zesty.getItem(for: zuid, { (item, error) in
    ///         if (error != nil) {
    ///             // error handling
    ///             return
    ///         }
    ///         print(item) // item is a [String : String] dictionary, in JSON Format
    ///     }
    /// - note: Using this function requires basic json endpoints to be [enabled](https://developer.zesty.io/guides/api/basic-api-json-endpoints-guide/).
    /// - parameters:
    ///   - zuid: The zuid for the item in question. It should start with a 7 when using this function
    ///   - completionHandler: Closure that handles the data once it is retrieved. If nothing is found, an empty array will be returned instead
    ///   - data: Returned through the closure, this is the [String : String] dictionary, in JSON Format
    public func getItem(for zuid: String, completionHandler: @escaping (_ data: [String : String], _ error: ZestyError?) -> Void) {
        let urlString = "\(self.baseURL)/-/basic-content/\(zuid).json"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            print(urlString)
            switch response.result {
            case .success((let value)):
                let json = JSON(value)
                if let stringJsonDict = json.dictionaryValue["data"] {
                    var stringStringDict = [String: String]()
                    stringJsonDict.forEach({ (key, valueJSON) in
                        stringStringDict[key] = valueJSON.stringValue
                    })
                    completionHandler(stringStringDict, nil)
                }
                else {
                    print("data incorrect shape. Go to <your_url>/-/basic-content/<zuid>.json to see if the json is loading properly. If the problem persists, contact support @ http://chat.zesty.io/")
                    
                    completionHandler([:], ZestyError.incorrectShape)
                }
                
                break
            case .failure(let error):
                print("ERROR DUE TO ALAMOFIRE\n\nERROR DESCRIPTION: ")
                print(error.localizedDescription)
                print("\n\nEND ERROR DESCRIPTION")
                completionHandler([:], ZestyError.alamofireError)
                break
            }
        }
    }
    
    /// Gets a `[[String : String]]` array of json data for the specific zuid.
    ///
    /// You can find the zuid by looking at the *Content* Tab of Zesty.
    ///
    /// Zuid Meanings and Functions to Use
    ///
    /// - Any zuid that starts with a **6** is an array of items (use `getArray`)
    /// - Any zuid that starts with a **7** is an object (use `getItem`)
    ///
    /// Sample Usage
    /// ==========
    ///
    /// Code
    /// ----
    ///
    /// For example, getting a specific item with zuid `7-9bfe5c-ntqxrs`
    ///
    ///     // Create the ZestySwiftContentEndpointWrapper Object
    ///     let zesty ZestySwiftContentEndpointWrapper(url: "http://burger.zesty.site")
    ///     let zuid = "7-9bfe5c-ntqxrs"
    ///
    ///     zesty.getArray(for: zuid, { (items, error) in
    ///         if (error != nil) {
    ///             // error handling
    ///             return
    ///         }
    ///         for item in items {
    ///             print(item) // item is a [String : String] dictionary, in JSON Format
    ///         }
    ///     }
    ///
    /// - parameters:
    ///   - zuid: The zuid for the item in question. It should start with a 6 when using this function
    ///   - completionHandler: Closure that handles the data once it is retrieved. If nothing is found, an empty array will be returned instead
    ///   - data: Returned through the closure, this is the [[String : String]] array of dictionaries
    public func getArray(for zuid: String, completionHandler: @escaping (_ data : [[String : String]], _ error: ZestyError?) -> Void) {
        let urlString = "\(self.baseURL)/-/basic-content/\(zuid).json"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            switch response.result {
            case .success((let value)):
                let json = JSON(value)
                //json["data"].arrayValue // list of dictionaries
                let stringJsonDictArray = json["data"].arrayValue
                var stringStringDictArray = [[String: String]]()
                stringJsonDictArray.forEach({ (stringJsonDict) in
                    var stringStringDict = [String: String]()
                    stringJsonDict.forEach({ (key, valueJSON) in
                        stringStringDict[key] = valueJSON.stringValue
                    })
                    stringStringDictArray.append(stringStringDict)
                })
                
                // now we have an array of dictionaries, with multiple versions per value.
                var d: [String : [String : String]] = [:]
                for dict in stringStringDictArray {
                    if let z = dict["_item_zuid"], let version = dict["_version"] {
                        if let val = d[z] {
                            // val is the [String : String] obj itself
                            if Int(val["_version"]!)! < Int(version)! { // if this new thing is a later version
                                d[zuid] = dict // update it
                            }
                        }
                        else {
                            d[zuid] = dict // initial placement of the zuid
                        }
                    }
                    else {
                        completionHandler([], ZestyError.incorrectShape)
                    }
                    
                    
                    
                }
                let toReturn = Array(d.values)
                completionHandler(toReturn, nil)
                break
            case .failure(let error):
                print("ERROR DUE TO ALAMOFIRE\n\nERROR DESCRIPTION: ")
                print(error.localizedDescription)
                print("\n\nEND ERROR DESCRIPTION")
                completionHandler([], ZestyError.alamofireError)
                break
            }
        }
    }
    
}

/// Custom Error Class for ZestySwiftContentEndpointWrapper Errors
///
/// Detailed error information can be found by accessing `localizedDescription`
///
/// Example Error Handling
/// =======
///
///     // Create the ZestySwiftContentEndpointWrapper Object
///     let zesty ZestySwiftContentEndpointWrapper(url: "http://burger.zesty.site")
///     let zuid = "6-9bfe5c-ntqxrs"
///
///     zesty.getItem(for: zuid, { (item, error) in
///         if (error != nil) {
///             print(error.localizedDescription)
///             // error handling
///         }
///         print(item) // item is a [String : String] dictionary, in JSON Format
///     }
///
/// ZestyError also supports error type handling
///
/// Error Case Handling:
/// ========
///
///     // Create the ZestySwiftContentEndpointWrapper Object
///     let zesty ZestySwiftContentEndpointWrapper(url: "http://burger.zesty.site")
///     let zuid = "6-9bfe5c-ntqxrs"
///
///     zesty.getItem(for: zuid, { (item, error) in
///         if (error != nil) {
///             switch (error) {
///                 case .noData:
///                     // write code to handle this
///                     break
///                 case .invalidURL:
///                     // write code to handle this
///                     break
///                 default:
///                     // you can also handle every type of error (there are 6 in total)
///                     break
///             }
///             // error handling
///         }
///         print(item) // item is a [String : String] dictionary, in JSON Format
///     }
///
public enum ZestyError : Error {
    /// Unknown Error Type. If the issue persists, contact support (https://chat.zesty.io)", comment: "Zesty Error
    case unknownError
    /// Error with Alamofire. See debug console for more information. This may be caused by an incorrect url or an insecure request
    case alamofireError
    /// Error with SwiftyJSON. See debug console for more information. This may be caused by invalid JSON
    case swiftyJsonError
    /// The URL / Endpoint / ZUID you are trying to access does not exist. Try making sure you can access the endpoint online
    case invalidURL
    /// No Data Was Found
    case noData
    /// The Data was in an unrecognizable shape. Try seeing if your endpoint is written correctly.
    case incorrectShape
    
    
    public var localizedDescription: String? {
        switch self {
        case .unknownError:
            return NSLocalizedString("Unknown Error Type. If the issue persists, contact support (https://chat.zesty.io)", comment: "Zesty Error")
        case .alamofireError:
            return NSLocalizedString("Error with Alamofire. See debug console for more information. This may be caused by an incorrect url or an insecure request", comment: "Zesty Error")
        case .swiftyJsonError:
            return NSLocalizedString("Error with SwiftyJSON. See debug console for more information. This may be caused by invalid JSON", comment: "Zesty Error")
        case .invalidURL:
            return NSLocalizedString("The URL / Endpoint / ZUID you are trying to access does not exist. Try making sure you can access the endpoint online.", comment: "Zesty Error")
        case .noData:
            return NSLocalizedString("No Data Was Found", comment: "Zesty Error")
        case .incorrectShape:
            return NSLocalizedString("The Data was in an unrecognizable shape. Try seeing if your endpoint is written correctly.", comment: "Zesty Error")
        }
    }
}
