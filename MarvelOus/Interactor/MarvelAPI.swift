//
//  MarvelAPI.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 05/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import CryptoSwift

struct KeyDict {
  let publicKey: String!
  let privateKey: String!
}

enum Type: String, CustomStringConvertible {
  case comics = "comics"
  case characters = "characters"
  case series = "series"
  case creators = "creators"
  case events = "events"
  case stories = "stories"
  
  var description: String {
    return self.rawValue
  }
}

class MarvelAPI {
  
  class func loadLocalComics() {
    if let path = Bundle.main.path(forResource: "Comics", ofType: "json") {
      do {
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
          try Comic.create(from: jsonResult)
        }
      } catch { print(error.localizedDescription) }
    }
  }
  
  func saveToFile(_ json: [String: Any]) {
    // Get the url of Comics.json in document directory
    guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileUrl = documentDirectoryUrl.appendingPathComponent("Comics.json")
    print(fileUrl)
    
    // Transform array into data and save it into file
    do {
      let data = try JSONSerialization.data(withJSONObject: json, options: [])
      try data.write(to: fileUrl, options: [])
    } catch {
      print(error)
    }
  }
  
  private var keys: NSDictionary?
  
  /// Read API Keys from stored property list
  ///
  /// - Returns: A dictionary containing the public key and private kye
  func getKeys() -> KeyDict {
    if let path = Bundle.main.path(forResource: "apikeys", ofType: "plist") {
      self.keys = NSDictionary(contentsOfFile: path)!
    }
    
    if let data = keys {
      return KeyDict(publicKey: data["publicKey"] as! String, privateKey: data["privateKey"] as! String)
    } else {
      return KeyDict(publicKey: "", privateKey: "")
    }
  }
  
  /**
   Forms the API url to retrieve a list of comics from marvel.com
   
   - Parameter limit:  The number of records to retrieve
   - Parameter offset: The number of records to skip
   
   - Parameter completion:  A completion block with the returned data
   - Parameter dataSet: Swift object translation of JSON response
   - Parameter results: Just the results part of the returned dataSet
   - Parameter errorString: reported errors from the transaction
   */
  func download(_ type: Type, first limit: Int, startingFrom offset: Int, completionHandler:  @escaping (DataResponse<Any>) -> Void) {
    let dict: KeyDict = self.getKeys()
    
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "gateway.marvel.com"
    urlComponents.path = "/v1/public/\(type.description)"
    
    let baseMarvelURL = urlComponents.url!
    let ts = NSDate().timeIntervalSince1970.description
    
    let params: Parameters = [
      "apikey": dict.publicKey!,
      "ts": ts,
      "hash": (ts + dict.privateKey! + dict.publicKey!).md5(),
      "orderBy": "-focDate",
      "limit" : limit,
      "offset" : offset,
      "hasDigitalIssue": "true"
    ]
    
    Alamofire.request(baseMarvelURL, parameters: params)
      .responseJSON { response in
        // Create Comics from JSON response
        if let json = response.result.value as? [String: Any] {
//          self.saveToFile(json)
          
          switch response.result {
          case .success:
            do {
              try Comic.create(from: json)
            } catch {
              print(error.localizedDescription)
            }
          case .failure(let error):
            print(error.localizedDescription)
          }
          completionHandler(response)
        }
    }
  }
  
//  func process(_ response: )
  
  func getData(for thumbnail: Thumbnail, from path: String, completionHandler: @escaping (DataResponse<Data>) -> Void) {
    
    if let url = URL(string: path + "/standard_xlarge.jpg") {
      //      print(url)
      Alamofire.request(url)
        .responseData { response in
          if let data = response.data {
            do {
              let realm = try Realm()
              try realm.write {
                thumbnail.data = data as NSData
              }
            } catch {
              print(error.localizedDescription)
            }
          } else {
            print("couldn't get image data")
          }
          completionHandler(response)
      }
    }
    // Download big thumbnail for DetailView
    if let bigUrl = URL(string: path + "/portrait_uncanny.jpg") {
      Alamofire.request(bigUrl)
        .responseData { response in
          if let data = response.data {
            do {
              let realm = try Realm()
              try realm.write {
                thumbnail.bigData = data as NSData
              }
            } catch {
              print(error.localizedDescription)
            }
          } else {
            print("couldn't get image data")
          }
      }
    }
  }
  
}
