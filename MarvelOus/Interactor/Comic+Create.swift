//
//  Comic+Create.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 07/05/2017.
//  Copyright © 2017 Wallapop. All rights reserved.
//

import RealmSwift

extension Comic {
  
  // Creates a Comic object with all linked objects from JSON download
  class func create(from json: [String: Any]) throws {
    do {
      let realm = try Realm()
      
      if let response = json["data"] as? [String: Any],
        let jsonResults = response["results"] as? [[String: Any]] {
        for json in jsonResults {
          try realm.write {
            
            let comic = realm.create(Comic.self, value: json, update: true)
            // description is a reserved name so we save it manually as desc
            if let desc = json["description"] as? String {
              comic.desc = desc
            }
          }
        }
      } else { print("No jsonResults") }
    } catch { throw error }
  }
    
}
