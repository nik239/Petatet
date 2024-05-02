//
//  Post.swift
//  Petatet
//
//  Created by Nikita Ivanov on 01/05/2024.
//

import Foundation

struct Post {
  let uid: String
  let time: Date?
  let postText: String?
}

extension Post: Decodable {
  enum CodingKeys: String, CodingKey {
    case user_id, time, postText
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.uid = try container.decode(String.self, forKey: .user_id)
    
    let timeString = try container.decode(String.self, forKey: .time)
    self.time = try? Date(timeString)

    let htmlString = try container.decode(String.self, forKey: .postText)
    self.postText = htmlString.stripHTML()
  }
}

extension Date {
  init(_ timeString: String) throws {
    if let dateDouble = Double(timeString) {
      self.init(timeIntervalSince1970: dateDouble)
    } else {
      throw "Couldn't create Date!"
    }
  }
}

extension String {
  func stripHTML() -> String? {
    guard let data = data(using: .utf8) else { return nil }
    do {
        return try NSAttributedString(data: data,
                                      options:[.documentType: NSAttributedString.DocumentType.html,        .characterEncoding: String.Encoding.utf8.rawValue],
                                      documentAttributes: nil).string
    } catch {
        return nil
    }
  }
}
