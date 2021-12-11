//
//  SearchDataModel.swift
//  Flicker
//
//  Created by Monica Pandey on 04/12/2021.
//

import Foundation

struct SearchResult: Codable {
  let photos: Photos?
  let stat: String
  let code: Int?
  let message: String?
}

struct Photos: Codable {
  let page: Int
  let pages: Int
  let perpage: Int
  let total: Int
  let photo: Array<PhotoInfo>
}

struct PhotoInfo: Codable {
  let id: String
  let owner: String
  let secret: String
  let server: String
  let farm: Int
  let title: String
  let ispublic: Int
  let isfriend: Int
  let isfamily: Int
}

