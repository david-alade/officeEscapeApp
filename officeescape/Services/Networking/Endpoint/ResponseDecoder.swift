//
//  ResponseDecoder.swift
//
//
//  Created by David Alade on 6/12/24.
//

import Foundation

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public struct JSONResponseDecoder: ResponseDecoder {
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

public struct VoidResponseDecoder: ResponseDecoder {
    public func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return VoidResponse() as! T
    }
}

public protocol DecodableResponse: Decodable {
    static var defaultDecoder: ResponseDecoder { get }
}

public extension DecodableResponse {
    static var defaultDecoder: ResponseDecoder {
        return JSONResponseDecoder()
    }
}

public struct VoidResponse: DecodableResponse {
    public static var defaultDecoder: ResponseDecoder {
        return VoidResponseDecoder()
    }
}

extension Array: DecodableResponse where Element: DecodableResponse {
    public static var defaultDecoder: ResponseDecoder {
        return JSONResponseDecoder()
    }
}

extension String: DecodableResponse {
    public static var defaultDecoder: ResponseDecoder {
        return JSONResponseDecoder()
    }
}

extension Int: DecodableResponse {
    public static var defaultDecoder: ResponseDecoder {
        return JSONResponseDecoder()
    }
}

extension Double: DecodableResponse {
    public static var defaultDecoder: ResponseDecoder {
        return JSONResponseDecoder()
    }
}

extension Bool: DecodableResponse {
    public static var defaultDecoder: ResponseDecoder {
        return JSONResponseDecoder()
    }
}

extension Optional: DecodableResponse where Wrapped: DecodableResponse {
    public static var defaultDecoder: ResponseDecoder {
        return Wrapped.defaultDecoder
    }
}
