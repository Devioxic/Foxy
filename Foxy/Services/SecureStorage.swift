//
//  SecureStorage.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-27.
//

import Foundation
import Security

class SecureStorage {
    
    static let shared = SecureStorage()
    
    private init() {}
    
    // Function to save data to the Keychain
    @discardableResult
    func save(key: String, value: String) -> Bool {
        let data = Data(value.utf8)
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        // Add data to Keychain
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            // If item already exists, update it
            return update(key: key, value: value)
        }
        
        return status == errSecSuccess
    }
    
    // Function to retrieve data from the Keychain
    func retrieve(key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    // Function to update data in the Keychain
    private func update(key: String, value: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        
        let attributesToUpdate = [
            kSecValueData: Data(value.utf8)
        ] as CFDictionary
        
        let status = SecItemUpdate(query, attributesToUpdate)
        return status == errSecSuccess
    }
    
    // Function to delete data from the Keychain
    func delete(key: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
}
