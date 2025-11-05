//
//  UserModel.swift
//  Zoetis -Feathers
//
//  Created by Nitin Agnihotri on 5/12/25.
//

import Foundation

class UserModel {
    
    // MARK: - Shared Instance
    static let shared = UserModel()
    // MARK: - Keys
    private enum Keys {
        static let userId = "Id"
        static let username = "username"
        static let firstName = "FirstName"
        static let lastName = "LastName"
        static let email = "email"
    }

    // MARK: - Stored Properties (with lazy fallback to UserDefaults)
    private var _userId: Int?
    private var _username: String?
    private var _firstName: String?
    private var _lastName: String?
    private var _email: String?

    var userId: Int? {
        get { _userId ?? UserDefaults.standard.integer(forKey: Keys.userId) }
    }

    var username: String? {
        get { _username ?? UserDefaults.standard.string(forKey: Keys.username) }
    }

    var firstName: String? {
        get { _firstName ?? UserDefaults.standard.string(forKey: Keys.firstName) }
    }

    var lastName: String? {
        get { _lastName ?? UserDefaults.standard.string(forKey: Keys.lastName) }
    }

    var email: String? {
        get { _email ?? UserDefaults.standard.string(forKey: Keys.email) }
    }

    // MARK: - Private Init
    private init() {}

    // MARK: - Public Methods
    func setUserData(userId: Int, username: String, firstName: String, lastName: String, email: String) {
        self._userId = userId
        self._username = username
        self._firstName = firstName
        self._lastName = lastName
        self._email = email
        
//        let defaults = UserDefaults.standard
//        defaults.set(userId, forKey: Keys.userId)
//        defaults.set(username, forKey: Keys.username)
//        defaults.set(firstName, forKey: Keys.firstName)
//        defaults.set(lastName, forKey: Keys.lastName)
//        defaults.set(email, forKey: Keys.email)
    }

    func clearUserData() {
        self._userId = nil
        self._username = nil
        self._firstName = nil
        self._lastName = nil
        self._email = nil

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Keys.userId)
        defaults.removeObject(forKey: Keys.username)
        defaults.removeObject(forKey: Keys.firstName)
        defaults.removeObject(forKey: Keys.lastName)
        defaults.removeObject(forKey: Keys.email)
    }
}

