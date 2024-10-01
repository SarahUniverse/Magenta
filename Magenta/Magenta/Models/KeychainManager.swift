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
        case duplicateItem
        case invalidItemFormat
        case unexpectedStatus(OSStatus)
    }

    static let shared = KeychainManager()

    private init() {}

    // Saves a password to the Keychain for a given account.
    func savePassword(password: String, for account: String) throws {
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

    // Retrieves password from the Keychain for a given account.
    func retrievePassword(for account: String) throws -> String {

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

    // Deletes a password from the Keychain for a given account.
    func deletePassword(for account: String) throws {
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
