//
//  SearchHistory.swift
//  Flicker
//
//  Created by Monica Pandey on 06/12/2021.
//

import Foundation

class SearchHistory {
  static var instance = SearchHistory()
  private var history: [History]
  private init() {
    self.history = [History]()
  }
  
  func addNewItem(item: History) {
    history.append(item)
  }
  
  func getHistory() -> [History] {
    return history
  }
  
}
