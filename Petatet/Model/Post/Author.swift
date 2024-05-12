//
//  Author.swift
//  Petatet
//
//  Created by Nikita Ivanov on 08/05/2024.
//

import Foundation

struct Author {
  
  let uid: String?
  let username: String?
  let name: Name
  let avatar: URL?
  
  var displayName: String? {
    if let first = name.first,
       let last = name.last,
       !first.isEmpty {
      return first + " " + last
    } else if let username = username {
      return username
    } else {
      return nil
    }
  }
}

extension Author: Decodable {
  enum CodingKeys: String, CodingKey {
    case user_id, username, first_name, last_name, avatar
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.uid = try? container.decode(String.self, forKey: .user_id)
    self.username = try? container.decode(String.self, forKey: .username)
    let first = try? container.decode(String.self, forKey: .first_name)
    let last = try? container.decode(String.self, forKey: .last_name)
    self.name = Name(first: first, last: last)
    if let avatar = try? container.decode(String.self, forKey: .avatar) {
      self.avatar = URL(string: avatar)
    } else {
      self.avatar = nil
    }
  }
}

extension Author {
  struct Name {
    let first: String?
    let last: String?
  }
}


