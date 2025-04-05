//
//  SessionManager.swift
//  app
//
//  Created by Onni Nevala on 4.4.2025.
//

import Foundation

var session: String {
    set {
        let sessionId = newValue
        let sessionData = sessionId.data(using: .utf8)!
        
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "sessionId"
        ]
        SecItemDelete(deleteQuery as CFDictionary)
        
        let saveQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "sessionId",
            kSecValueData as String: sessionData
        ]
        
        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        
        if status != errSecSuccess {
            fatalError("Panicking on failed keychain save \(status)")
        }
    }
    get {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "sessionId",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status != errSecSuccess {
            print("Failed to retrieve keychain: \(status)")
            return ""
        }
        
        return String(data: item as! Data, encoding: .utf8)!
    }
}


var loginToken: String {
    set {
        let sessionId = newValue
        let sessionData = sessionId.data(using: .utf8)!
        
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "loginToken"
        ]
        SecItemDelete(deleteQuery as CFDictionary)
        
        let saveQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "loginToken",
            kSecValueData as String: sessionData
        ]
        
        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        
        if status != errSecSuccess {
            fatalError("Panicking on failed keychain save \(status)")
        }
    }
    get {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "loginToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status != errSecSuccess {
            print("Failed to retrieve keychain: \(status)")
            return ""
        }
        
        return String(data: item as! Data, encoding: .utf8)!
    }
}

