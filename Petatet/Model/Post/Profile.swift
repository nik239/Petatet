//
//  Author.swift
//  Petatet
//
//  Created by Nikita Ivanov on 08/05/2024.
//

import Foundation

struct Profile: Hashable {
  static func == (lhs: Profile, rhs: Profile) -> Bool {
    lhs.uid == rhs.uid
  }
  
  let uid: String?
  let username: String?
  let name: Name
  let avatar: URL?
  let details: Details?
  let isFollowing: Int?
  
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

extension Profile: Decodable {
  enum CodingKeys: String, CodingKey {
    case user_id, username, first_name, last_name, avatar, details, is_following
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.uid = try? container.decode(String.self, forKey: .user_id)
    self.username = try? container.decode(String.self, forKey: .username)
    let first = try? container.decode(String.self, forKey: .first_name)
    let last = try? container.decode(String.self, forKey: .last_name)
    self.details = try? container.decode(Details.self, forKey: .details)
    self.isFollowing = try? container.decode(Int.self, forKey: .is_following)
    self.name = Name(first: first, last: last)
    if let avatar = try? container.decode(String.self, forKey: .avatar) {
      self.avatar = URL(string: avatar)
    } else {
      self.avatar = nil
    }
  }
}

extension Profile {
  struct Name: Hashable {
    let first: String?
    let last: String?
  }
}

extension Profile {
  struct Details: Decodable, Hashable {
    let postCount: String
    let followersCount: String
    let followingCount: String
    
    init(postCount: String, followersCount: String, followingCount: String) {
      self.postCount = postCount
      self.followersCount = followersCount
      self.followingCount = followingCount
    }
    
    enum CodingKeys: String, CodingKey {
      case post_count, following_count, followers_count
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.postCount = try container.decode(String.self, forKey: .post_count)
      self.followersCount = try container.decode(String.self, forKey: .followers_count)
      self.followingCount = try container.decode(String.self, forKey: .following_count)
    }
  }
}

//MARK: -Preview
extension Profile {
  static let preview = Profile(uid: "1",
                               username: "aceventura",
                               name: Profile.Name(first: "Ace",
                                                  last: "Ventura"),
                               avatar: LocalFiles.avatar,
                               details: Details(postCount: "42",
                                                followersCount: "239",
                                                followingCount: "1203"),
                               isFollowing: 0)
}


