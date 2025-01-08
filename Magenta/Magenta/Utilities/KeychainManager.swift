//
//  KeychainManager.swift
//  Magenta
//
//  Created by Sarah Clark on 9/29/24.
//

import Foundation
import Security

class KeychainManager {

    enum KeychainError: Error {
        case itemNotFound
        case deletionError
        case duplicateItem
        case invalidItemFormat
        case unexpectedStatus(OSStatus)
    }

    static let shared = KeychainManager()

    private init() {}

    func savePasswordToKeychain(password: String, for account: String) throws {
        let passwordData = password.data(using: String.Encoding.utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: passwordData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == noErr else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    func retrievePasswordFromKeychain(for account: String) throws -> String {

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }

        guard status == noErr else {
            throw KeychainError.unexpectedStatus(status)
        }

        guard let passwordData = item as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8) else {
            throw KeychainError.invalidItemFormat
        }
        return password
    }

    func retrieveAccountNameFromKeychain(for userName: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: kCFBooleanTrue as Any
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == noErr else {
                print("\(status)")
                return nil
            }

        guard let existingItem = item as? [String: Any],
              let accountNameData = existingItem[kSecAttrAccount as String] as? String else {
            print("Failed to retrieve or cast account name")
            return nil
        }

        return accountNameData
    }

    func deletePasswordFromKeychain(for account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

}
