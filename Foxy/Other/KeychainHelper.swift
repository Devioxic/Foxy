//
//  KeychainHelper.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-23.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    
    private init() {}
    
    func save(_ value : String, for key : String) {
        let data = Data(value.utf8)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            print("Error adding: \(status)")
        }
    }
    
    func read(for key: String) -> String? {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecReturnData: true,
                kSecMatchLimit: kSecMatchLimitOne
            ] as CFDictionary
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query, &result)
            
            if status == errSecSuccess {
                if let data = result as? Data {
                    return String(data: data, encoding: .utf8)
                }
            } else {
                print("Error reading: \(status)")
            }
            
            return nil
        }
        
        func delete(for key: String) {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key
            ] as CFDictionary
            
            let status = SecItemDelete(query)
            
            if status != errSecSuccess {
                print("Error deleting: \(status)")
            }
        }
}
