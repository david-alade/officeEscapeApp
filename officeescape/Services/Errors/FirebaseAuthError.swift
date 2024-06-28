//
//  FirebaseAuthError.swift
//  bibite
//
//  Created by David Alade on 12/6/23.
//

import Foundation

enum FirebaseAuthError: Error {
    case generalError(GeneralError)
    case createUserError(CreateUserError)
    case firebaseUserError(FirebaseUserError)
    case signInError(SignInError)
    case signOutError(SignOutError)
    case unknownError(String)
    case phoneAuthError(PhoneAuthError)
    
    enum PhoneAuthError: Error {
        case invalidPhoneNumber
        case quotaExceeded
        case captchaCheckFailed
        case invalidVerificationCode
        case invalidVerificationID
        case missingPhoneNumber
        case tooManyRequests
        
        var localizedDescription: String {
            switch self {
            case .invalidPhoneNumber:
                return "Invalid phone number format."
            case .quotaExceeded:
                return "Phone authentication quota exceeded."
            case .captchaCheckFailed:
                return "CAPTCHA verification failed."
            case .invalidVerificationCode:
                return "Invalid verification code."
            case .invalidVerificationID:
                return "Invalid verification ID."
            case .missingPhoneNumber:
                return "Missing phone number."
            case .tooManyRequests:
                return "Too many requests for phone authentication."
            }
        }
    }
    
    enum GeneralError: Error {
        case networkError
        case userNotFound
        case userTokenExpired
        case tooManyRequests
        case internalError
        
        var localizedDescription: String {
            switch self {
            case .networkError:
                return "Network Error"
            case .userNotFound:
                return "User not found / may be deleted."
            case .userTokenExpired:
                return "Token is expired. Must sign in again."
            case .tooManyRequests:
                return "Too many requests. Try again later."
            case .internalError:
                return "Internal error"
            }
        }
    }
    
    enum CreateUserError: Error {
        case emailAlreadyInUse
        case weakPassword
        case invalidEmail
        
        var localizedDescription: String {
            switch self {
            case .invalidEmail:
                return "Invalid email address."
            case .emailAlreadyInUse:
                return "Email already in use."
            case .weakPassword:
                return "Password is too weak."
            }
        }
    }
    
    enum FirebaseUserError: Error {
        case invalidUserToken
        case accountDisabled
        
        var localizedDescription: String {
            switch self {
            case .invalidUserToken:
                return "Token is invalid. Must sign in again."
            case .accountDisabled:
                return "Account is disabled"
            }
        }
    }
    
    enum SignInError: Error {
        case invalidEmail
        case wrongPassword
        case userNotFound
        
        var localizedDescription: String {
            switch self {
            case .invalidEmail:
                return "Invalid email address."
            case .wrongPassword:
                return "Incorrect password."
            case .userNotFound:
                return "User not found."
            }
        }
    }
    
    enum SignOutError: Error {
        case keychainError
        
        var localizedDescription: String {
            return "Keychain error"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .generalError(let error):
            return error.localizedDescription
        case .createUserError(let error):
            return error.localizedDescription
        case .firebaseUserError(let error):
            return error.localizedDescription
        case .signInError(let error):
            return error.localizedDescription
        case .signOutError(let error):
            return error.localizedDescription
        case .unknownError(let message):
            return message
        case .phoneAuthError(let error):
            return error.localizedDescription
        }
    }
}

