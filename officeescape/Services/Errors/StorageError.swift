//
//  StorageError.swift
//  bibite
//
//  Created by David Alade on 2/11/24.
//

import Foundation

enum StorageError: Error {
    case uploadError(String)
    case unknownError
    
    var localizedDesccription: String {
        switch self {
        case .uploadError(let string):
            "Upload error"
        case .unknownError:
            "Unknown error"
        }
    }
}
