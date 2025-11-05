//
//  CryptoHelper.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 20/01/21.
//

import Foundation

import CryptoSwift

public class CryptoHelper{
   
   private static let encodedKey = "TjVPM2dWWG5HenVydFB0Tw==";//16 char secret key
   private static var key = "";//16 char secret key
//   private static let key = "N5O3gVXnGzurtPtO";//16 char secret key
   
   public static func encrypt(input:String)->String{
       do{
           if let decodedData = Data(base64Encoded: encodedKey),
              let decodedKey = String(data: decodedData, encoding: .utf8) {
               key = decodedKey
               let encrypted: Array<UInt8> = try AES(key: key, iv: key, padding: .pkcs5).encrypt(Array(input.utf8))
               return encrypted.toBase64()
           }
       }catch{
           
       }
       return ""
   }
   
   public static func decrypt(input:String)->String?{
       do{
           let d=Data(base64Encoded: input)
           
           if let decodedData = Data(base64Encoded: encodedKey),
              let decodedKey = String(data: decodedData, encoding: .utf8) {
               key = decodedKey
               let decrypted = try AES(key: key, iv: key, padding: .pkcs5).decrypt(
                   d!.bytes)
               return String(data: Data(decrypted), encoding: .utf8)
           }
       }catch{
           
       }
       return nil
   }
}
