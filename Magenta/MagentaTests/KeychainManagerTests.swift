//
//  KeychainManagerTests.swift
//  MagentaTests
//
//  Created by Sarah Clark on 10/1/24.
//

import Testing
@testable import Magenta


// TODO: Fix tests (or actual code) so they consistently pass.
final class KeychainManagerTests {

    var keychainManager: KeychainManager!
    let testAccount = "testUser"
    let testPassword = "secureTestPassword123"

    init() async throws {
        keychainManager = KeychainManager.shared
        // Clear out any existing test data before each test.
        try? keychainManager.deletePasswordFromKeychain(for: testAccount)
    }

    deinit {
        try? keychainManager.deletePasswordFromKeychain(for: testAccount)
    }

    @Test func testSaveAndRetrievePassword() throws {
        try keychainManager.savePasswordToKeychain(password: testPassword, for: testAccount)
        let retrievedPassword = try keychainManager.retrievePasswordFromKeychain(for: testAccount)

        #expect(retrievedPassword == testPassword)
    }

    @Test func testPasswordNotFound() throws {
        do {
            _ = try keychainManager.retrievePasswordFromKeychain(for: "nonExistentUser")
            Issue.record("Should throw itemNotFound error")
        } catch KeychainManager.KeychainError.itemNotFound {
            // Success, we expect this error
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func testRetrieveAccountName() throws {
        // Assuming saving works from previous tests, let's test retrieving an account name.
        do {
            try keychainManager.savePasswordToKeychain(password: testPassword, for: testAccount)
            let accountName = keychainManager.retrieveAccountNameFromKeychain(for: testAccount)
            #expect(accountName == testAccount)
        } catch {
            Issue.record("Failed with error: \(error)")
        }
    }

    @Test func testDeletePassword() throws {
        //try keychainManager.savePasswordToKeychain(password: testPassword, for: testAccount)
        try keychainManager.deletePasswordFromKeychain(for: testAccount)

        do {
            _ = try keychainManager.retrievePasswordFromKeychain(for: testAccount)
            Issue.record("Password should have been deleted and retrieval should fail")
        } catch KeychainManager.KeychainError.itemNotFound {
            // Success, the item should not be found
        } catch {
            Issue.record("Unexpected error after deletion: \(error)")
        }
    }

}
