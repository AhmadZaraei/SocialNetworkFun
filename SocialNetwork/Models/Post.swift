//
//  Post.swift
//  SocialNetwork
//
//  Created by Ahmad Zaraei on 10/18/17.
//  Copyright © 2017 Ahmad Zaraei. All rights reserved.
//

import Foundation

class Post {
  private var _caption: String!
  private var _likes: Int!
  private var _imageUrl: String!
  private var _postKey: String!

  var caption: String {
    return _caption
  }
  var likes: Int {
    return _likes
  }
  var imageUrl: String {
    return _imageUrl
  }
  var postKey: String {
    return _postKey
  }

  init(caption:String, imageUrl:String, likes:Int) {
    self._caption = caption
    self._likes = likes
    self._imageUrl = imageUrl
  }

  init(postKey: String, postData: Dictionary<String, AnyObject>) {
    self._postKey = postKey

    if let caption = postData["caption"] as? String {
      _caption = caption
    }
    if let imageUrl = postData["imageUrl"] as? String {
      _imageUrl = imageUrl
    }
    if let likes = postData["likes"] as? Int {
      _likes = likes
    }
  }
}
