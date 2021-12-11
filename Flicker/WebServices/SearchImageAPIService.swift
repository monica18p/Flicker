//
//  SearchImageAPIService.swift
//  Flicker
//
//  Created by Monica Pandey on 04/12/2021.
//

import Foundation

class SearchImageAPIService {
  
  static func searchImage(searchText: String) async throws -> SearchResult {
    if searchText.isEmpty == true { throw APIError.SearchTextIsBlank }
    
    var url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1"
    url += "&" + "api_key=" + FlickrServiceCredentials.APIKey
    url += "&" + "text=" + searchText
    
    let data = try await APIService.postMethod(urlString: url)
    let serialisedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    
    guard let stat = serialisedData?["stat"] as? String else { throw APIError.IncorrectResponseFormat}
    if stat == "fail" {
      print("stat is fail")
    } else {
      print("stat is \(stat)")
    }
    
    guard let result = try? JSONDecoder().decode(SearchResult.self, from: data)
    else { throw APIError.IncorrectResponseFormat }
    
    return result
  }
  
  static func downloadImage(info: PhotoInfo) async throws -> Data {
    var url = "http://farm"
    url += String(info.farm)
    url += ".static.flickr.com/"
    url += info.server + "/"
    url += info.id + "_" + info.secret + ".jpg"
    
    let data = try await APIService.postMethod(urlString: url)
    return data
  }
  
}
