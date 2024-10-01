//
//  KeychainManagerTests.swift
//  MagentaTests
//
//  Created by Sarah Clark on 10/1/24.
//

import XCTest
@testable import Magenta

class KeychainManagerTests: XCTestCase {

    var keychainManager: KeychainManager!
    let testAccount = "testUser"
    let testPassword = "secureTestPassword123"

    override func setUp() {
        super.setUp()
        keychainManager = KeychainManager.shared
        // Clear out any existing test data before each test
        try? keychainManager.deletePasswordFromKeychain(for: testAccount)
    }

    func testSaveAndRetrievePassword() throws {
        // Save a password
        try keychainManager.savePasswordToKeychain(password: testPassword, for: testAccount)

        // Retrieve the password
        let retrievedPassword = try keychainManager.retrievePasswordFromKeychain(for: testAccount)

        XCTAssertEqual(retrievedPassword, testPassword, "The retrieved password should match the saved password.")
    }

    func testPasswordNotFound() throws {
        do {
            _ = try keychainManager.retrievePasswordFromKeychain(for: "nonExistentUser")
            XCTFail("Should throw itemNotFound error")
        } catch KeychainManager.KeychainError.itemNotFound {
            // Success, we expect this error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRetrieveAccountName() {
        // Assuming saving works from previous tests, let's test retrieving an account name
        do {
            try keychainManager.savePasswordToKeychain(password: testPassword, for: testAccount)
            let accountName = keychainManager.retrieveAccountNameFromKeychain(for: testAccount)
            XCTAssertEqual(accountName, testAccount, "Account names should match")
        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

    func testDeletePassword() throws {
        // Save a password
        try keychainManager.savePasswordToKeychain(password: testPassword, for: testAccount)

        // Delete the password
        try keychainManager.deletePasswordFromKeychain(for: testAccount)

        do {
            // Attempt to retrieve the password after deletion
            _ = try keychainManager.retrievePasswordFromKeychain(for: testAccount)
            XCTFail("Password should have been deleted and retrieval should fail")
        } catch KeychainManager.KeychainError.itemNotFound {
            // Success, the item should not be found
        } catch {
            XCTFail("Unexpected error after deletion: \(error)")
        }
    }

    func testDuplicateSave() throws {
        try keychainManager.savePasswordToKeychain(password: testPassword, for: testAccount)

        // Try saving again, which should not throw an error but might update the password
        try keychainManager.savePasswordToKeychain(password: "newPassword", for: testAccount)

        // Check if password was updated
        let newPassword = try keychainManager.retrievePasswordFromKeychain(for: testAccount)
        XCTAssertEqual(newPassword, "newPassword", "The password should have been updated.")
    }

    override func tearDown() {
        // Ensure test data is cleaned up after each test
        try? keychainManager.deletePasswordFromKeychain(for: testAccount)
        super.tearDown()
    }
}
