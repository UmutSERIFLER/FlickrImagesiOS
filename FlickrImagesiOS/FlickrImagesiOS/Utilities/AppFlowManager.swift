//
//  AppFlowManager.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import Foundation


enum UserDefaultKeys: String {
    case lastSearches = "lastSearches"
}

class AppFlowManager {
    static let shared = AppFlowManager()
    
    func saveValue(value:Any?, key: UserDefaultKeys){
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func removeValue(key: UserDefaultKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func values(key: UserDefaultKeys) -> [Any] {
        return UserDefaults.standard.array(forKey: key.rawValue) ?? []
    }
    
}
