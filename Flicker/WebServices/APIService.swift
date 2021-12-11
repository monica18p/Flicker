//
//  APIService.swift
//  Flicker
//
//  Created by Monica Pandey on 04/12/2021.
//

import Foundation

enum APIError: Error {
  case UnableToCreateURL
  case ServerError
  case IncorrectResponseFormat
  case SearchTextIsBlank
}

extension APIError: LocalizedError {
  public var errorDescription: String {
    switch self {
    case .UnableToCreateURL:
      return "Unable to create url"
    case .ServerError:
      return "Server sent error"
    case .IncorrectResponseFormat:
      return "Incorrect response format"
    case .SearchTextIsBlank:
      return "Search text is blank"
    default:
      return "Something went wrong"
    }
  }
}

class APIService {
  static func postMethod(urlString: String) async throws -> Data {
    guard let url = URL(string: urlString) else {
      throw APIError.UnableToCreateURL
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw APIError.ServerError
    }
    
    return data
  }
}

struct FlickrServiceCredentials {
  static let APIKey = "24ce009b3037056254f13aac7c20d51f"
  static let Secret = "031044ba96a547c9"
}
