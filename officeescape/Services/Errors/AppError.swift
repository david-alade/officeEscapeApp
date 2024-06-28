//
//  AppError.swift
//  bibite
//
//  Created by David Alade on 2/1/24.
//

import Foundation

enum AppError: Error, LocalizedError {
    case auth(FirebaseAuthError)
    case network(NetworkError)
    case storage(StorageError)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .auth(let authError):
            return "Authentication Error: \(authError.localizedDescription)"
        case .network(let networkError):
            return "Network Error: \(networkError.localizedDescription)"
        case .storage(let storageError):
            return "Storage error: \(storageError.localizedDesccription)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
