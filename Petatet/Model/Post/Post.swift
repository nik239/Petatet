//
//  Post.swift
//  Petatet
//
//  Created by Nikita Ivanov on 01/05/2024.
//

import Foundation

enum AttachedMedia {
  case video(URL)
  case photo(URL)
  case photos([URL])
}

struct Post: Identifiable {
  let uid: String
  let time: Date?
  let postText: String?
  let attachedMedia: AttachedMedia
  let author: Author?
  let likeCount: Int?
  public var id: UUID
}

extension Post: Decodable {
  enum CodingKeys: String, CodingKey {
    case user_id, time, postText, photo_album, photo_multi, postFile, publisher, reaction
  }
  
  init(from decoder: Decoder) throws {
    self.id = UUID()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.uid = try container.decode(String.self, forKey: .user_id)
    
    let timeStamp = try container.decode(String.self, forKey: .time)
    self.time = try Date(timeStamp)

    let htmlString = try container.decode(String.self, forKey: .postText)
    self.postText = htmlString.stripHTML()
    
    self.author = try! container.decode(Author.self, forKey: .publisher)
    let likes = try? container.decode(Likes.self, forKey: .reaction)
    self.likeCount = likes?.count
    
    var media = [String]()
    
    if let postFile = try? container.decode(String.self, forKey: .postFile),
       let postFileURL = URL(string: postFile) {
      if postFileURL.isVideoURL() {
        self.attachedMedia = .video(postFileURL)
      } else {
        self.attachedMedia = .photo(postFileURL)
      }
      return
    }
    
    if let photoAlbum = try? container.decode([PhotoObject].self, forKey: .photo_album) {
      media += photoAlbum.map { $0.image }
    }
    if let photoMulti = try? container.decode([PhotoObject].self, forKey: .photo_multi) {
      media += photoMulti.map { $0.image }
    }
    
    let mediaURLs = media.compactMap { URL(string: $0) }
    self.attachedMedia = .photos(mediaURLs)
  }
}


//extension Post

//extension Post: Identifiable {
//  public var id: String {
//    return uid
//  }
//}

extension Date {
  init(_ timeStamp: String) throws {
    if let dateDouble = Double(timeStamp) {
      self.init(timeIntervalSince1970: dateDouble)
    } else {
      throw "Failed to init Double from String timeStamp."
    }
  }
}

extension URL: Identifiable {
  public var id: URL {
    return self
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
