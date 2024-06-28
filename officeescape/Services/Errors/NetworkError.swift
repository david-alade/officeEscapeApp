//
//  NetworkError.swift
//
//
//  Created by David Alade on 6/12/24.
//

public enum NetworkError: Error {
    case urlError
    case decodingError
    case httpError(Int, String)
    case unknownError
    case endpointError(EndpointError)
    case fileUploadError(String)
    
    var localizedDescription: String {
        switch self {
        case .urlError:
            "Url error"
        case .decodingError:
            "Decoding error"
        case .httpError(_, let message):
            message
        case .unknownError:
            "Unknown error"
        case .endpointError(let endpointError):
            switch endpointError {
            case .encodingError:
                "Endpoint encoding error"
            case .tokenCreationError:
                "Token error"
            }
        case .fileUploadError:
            "File upload error"
        }
    }
}
