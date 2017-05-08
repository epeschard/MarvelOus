//
//  Comic.swift
//  MarvelOus
//
//  Created by Eugène Peschard on 05/05/2017.
//

import RealmSwift

class Comic: Object {
  dynamic var id = 0
  dynamic var digitalId = 0
  dynamic var title: String?
  dynamic var issueNumber = 0
  dynamic var variantDescription: String?
  dynamic var desc: String?
  dynamic var modified: String? //TODO: Change to Date
  dynamic var isbn: String?
  dynamic var upc: String?
  dynamic var diamondCode: String?
  dynamic var ean: String?
  dynamic var issn: String?
  dynamic var format: String?
  dynamic var pageCount = 0
  let textObjects = List<TextObject>()
  dynamic var resourceURI: String?
  let urls = List<Url>()
  dynamic var series: Series?
  let variants = List<ComicSummary>()
  let collections = List<ComicSummary>()
  let collectedIssues = List<ComicSummary>()
  let dates = List<Dates>()
  let prices = List<Price>()
  dynamic var thumbnail: Thumbnail?
  let images = List<Images>()
  dynamic var creators: CreatorList?
  dynamic var characters: CharacterList?
//  dynamic var stories: StoryList?
//  dynamic var events: EventList?
  
  override class func primaryKey() -> String? { return "resourceURI" }
}

class TextObject: Object {
  dynamic var type: String?
  dynamic var language: String?
  dynamic var text: String?
}

class Url: Object {
  dynamic var type: String?
  dynamic var url: String?
}

class ComicSummary: Object {
  dynamic var resourceURI: String?
  dynamic var name = ""
}

class CreatorList: Object {
  dynamic var available = 0
  dynamic var returned = 0
  dynamic var collectionURI: String?
  let items = List<Creator>()
}

class CharacterList: Object {
  dynamic var available = 0
  dynamic var returned = 0
  dynamic var collectionURI: String?
  let items = List<Character>()
}

//class Character: Object {
//  dynamic var resourceURI: String?
//  dynamic var name = ""
//  dynamic var role: String?
//  
//  override class func primaryKey() -> String? { return "name" }
//}

//class StoryList: Object {
//  dynamic var available = 0
//  dynamic var returned = 0
//  dynamic var collectionURI: String?
//  let items = List<StorySummary>()
//}
//
//class StorySummary: Object {
//  dynamic var resourceURI: String?
//  dynamic var name = ""
//  dynamic var role: String?
//  
//  override class func primaryKey() -> String? { return "name" }
//}
//
//class EventList: Object {
//  dynamic var available = 0
//  dynamic var returned = 0
//  dynamic var collectionURI: String?
//  let items = List<EventSummary>()
//}
//
//class EventSummary: Object {
//  dynamic var resourceURI: String?
//  dynamic var name = ""
//  dynamic var role: String?
//  
//  override class func primaryKey() -> String? { return "name" }
//}
