//
//  NetworkErrorHandler.swift
//  Zoetis -Feathers
//
//  Created by Mobile Programming on 28/10/25.
//

import Foundation
import Alamofire

class NetworkErrorHandler {
    
    /// Returns a user-friendly error message for any Alamofire / URLError / NSError
    static func getUserFriendlyMessage(from error: Error) -> String {
        
        // 1️⃣ Direct URLError
        if let urlError = error as? URLError {
            return message(for: urlError)
        }
        
        // 2️⃣ AFError that may wrap a URLError
        if let afError = error.asAFError {
            switch afError {
                
                // Specifically handles your case:
            case .sessionTaskFailed(let underlyingError as URLError):
                return message(for: underlyingError)
                
            case .sessionTaskFailed(let underlyingError):
                // It may still contain something useful
                let nsError = underlyingError as NSError
                if nsError.domain == NSURLErrorDomain {
                    let urlError = URLError.Code(rawValue: nsError.code)
                    return message(for: URLError(urlError))
                }
                return "Request failed due to a network error. Please try again."
                
                // Handle encoding/decoding issues
            case .responseSerializationFailed:
                return "Server returned unexpected data format."
            case .multipartEncodingFailed:
                return "File upload failed due to an encoding issue."
            default:
                break
            }
        }
        
        // 3️⃣ NSError directly from URLSession
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            let urlError = URLError.Code(rawValue: nsError.code)
            return message(for: URLError(urlError))
        }
        
        // 4️⃣ Fallback
        return "Something went wrong. Please try again."
    }
    
    // MARK: - Centralized mapping
    private static func message(for urlError: URLError) -> String {
        switch urlError.code {
            
            // MARK: - Connectivity
        case .notConnectedToInternet:           // -1009
            return "No internet connection. Please check your network and try again."
            
        case .timedOut:                         // -1001
            return "The request timed out. Please check your internet connection and try again."
            
        case .networkConnectionLost:            // -1005
            return "Network connection was lost during upload. Please reconnect and retry."
            
        case .cannotFindHost:                   // -1003
            return "Cannot find the server. Please check your internet or try again later."
            
        case .cannotConnectToHost:              // -1004
            return "Unable to connect to the server. It might be down temporarily."
            
        case .dnsLookupFailed:                  // -1006
            return "Server address not found. Please verify your internet connection."

        case .dataNotAllowed:                   // -1020
            return "Mobile data is restricted. Please enable data access for this app."

        // MARK: - Authentication / User Cancellation
        case .userAuthenticationRequired:       // -1013
            return "Authentication is required to complete this action. Please login again."
            
        case .userCancelledAuthentication:      // -1012
            return "Authentication failed or was cancelled. Please try logging in again."

        // MARK: - SSL / Security
        case .secureConnectionFailed,           // -1200
             .serverCertificateUntrusted,       // -1202
             .serverCertificateHasBadDate,      // -1201
             .serverCertificateHasUnknownRoot,  // -1203
             .serverCertificateNotYetValid:     // -1204
            return "Secure connection failed. Please ensure your network allows HTTPS traffic."

        // MARK: - Response / Parsing
        case .badServerResponse,                // -1011
             .cannotDecodeContentData,          // -1016
             .cannotDecodeRawData:              // -1015
            return "Invalid or unreadable server response. Please try again later."
            
        case .cannotParseResponse:              // -1017
            return "The server returned data in an unexpected format. Please try again later."

        // MARK: - Request Cancelled (e.g. navigation, background)
        case .cancelled:                        // -999
            return "The request was cancelled before completion."

        // MARK: - Security / Proxy
        case .secureConnectionFailed:           // -1200
            return "Secure connection failed. Please check your Wi-Fi or VPN settings."

        // MARK: - Fallback
        default:
            return "Unexpected network error (\(urlError.code.rawValue)): \(urlError.localizedDescription)"
        }
    }

}


