//
//  PasswordService.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 20/01/21.
//

import Foundation
import JNKeychain

final class PasswordService{
    private init(){print("Initializer")}
    static let shared = PasswordService()
    
    func getPassword() -> String{
        return keychain_valueForKey("pePassword") as? String ?? ""
    }
    
    func setPassword(password:String ){
        keychain_setObject(password as AnyObject  , forKey: "pePassword")
    }
    
    func deletePassword(){
        keychain_deleteObjectForKey("pePassword")
    }
    
    func getUsername() -> String{
        return keychain_valueForKey("peUsername") as? String ?? ""
    }
    
    func setUsername(password:String ){
        keychain_setObject(password as AnyObject  , forKey: "peUsername")
    }
    
    func deleteUsername(){
        keychain_deleteObjectForKey("peUsername")
    }
    
    func keychain_setObject(_ object: AnyObject, forKey: String) {
        let result = JNKeychain.saveValue(object, forKey: forKey)
        if !result {
            print("keychain saving: smth went wrong")
        }
    }
    
    func keychain_deleteObjectForKey(_ key: String) -> Bool {
        let result = JNKeychain.deleteValue(forKey: key)
        return result
    }
    
    func keychain_valueForKey(_ key: String) -> AnyObject? {
        let value = JNKeychain.loadValue(forKey: key)
        return value as AnyObject?
    }
}
