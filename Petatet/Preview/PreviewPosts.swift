//
//  PreviewPosts.swift
//  Petatet
//
//  Created by Nikita Ivanov on 08/05/2024.
//

import Foundation

struct PreviewPosts {
  static let author = Profile(uid: "1",
                      username: "ace" ,
                      name: Profile.Name(first: "Ace",
                                        last: "Ventura"),
                      avatar: LocalFiles.avatar)
  
  let posts: [Post] = [
    Post(uid: "1",
         postID: "1",
         time: .now,
         postText: "This is a long dog",
         attachedMedia: .photo(LocalFiles.longDog),
         author: author,
         likeCount: 0,
         id: UUID()),
    Post(uid: "2",
         postID: "2",
         time: .now,
         postText: "Two dogs",
         attachedMedia: .photos([LocalFiles.dog, LocalFiles.longDog]),
         author: author,
         likeCount: 0,
         id: UUID()),
    Post(uid: "3",
         postID: "3",
         time: .now,
         postText: "A dog video. A video about dog. This text is long to test how line limit looks when text is long",
         attachedMedia: .video(LocalFiles.dogMovie),
         author: author,
         likeCount: 0,
         id: UUID())
  ]
}

struct LocalFiles {
  static var dog: URL {
    Bundle.main.url(forResource: "Dog", withExtension: "jpg")!
  }
  static var longDog: URL {
    Bundle.main.url(forResource: "LongDog", withExtension: "jpg")!
  }
  static var dogMovie: URL {
    Bundle.main.url(forResource: "DogMovie", withExtension: "mov")!
  }
  static var avatar: URL {
    Bundle.main.url(forResource: "avatar", withExtension: "jpg")!
  }
}
