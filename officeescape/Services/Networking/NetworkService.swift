//
//  TruthNetworking.swift
//
//
//  Created by David Alade on 6/12/24.
//

import Combine
import Foundation
import UniformTypeIdentifiers

public final class NetworkService: NetworkServiceProtocol {
    private var uploadProgressObservation: NSKeyValueObservation?
    
    public func request<T: DecodableResponse>(_ endpoint: Endpoint<T>) -> AnyPublisher<T, NetworkError> {
        guard let request = endpoint.request() else {
            return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                let data = try self.handleHTTPResponse(output.response, data: output.data)
                return data
            }
            .tryMap { data -> T in
                return try endpoint.decoder.decode(data) as T
            }
            .mapError { error -> NetworkError in
                print("Error: \(error)")
                switch error {
                case is DecodingError:
                    return NetworkError.decodingError
                case let networkError as NetworkError:
                    return networkError
                default:
                    return NetworkError.unknownError
                }
            }.eraseToAnyPublisher()
    }
    
    func upload<T: DecodableResponse>(fileURL: URL, endpoint: Endpoint<T>) -> AnyPublisher<UploadTaskResponse<T>, NetworkError> {
        guard var request = endpoint.request() else {
            return Fail(error: NetworkError.urlError).eraseToAnyPublisher()
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let subject = PassthroughSubject<UploadTaskResponse<T>, NetworkError>()
        
        do {
            let formData = try createMultipartFormData(fileURL: fileURL, boundary: boundary)
            
            let uploadTask = URLSession.shared.uploadTask(with: request, from: formData) { data, response, error in
                if let error = error {
                    subject.send(completion: .failure(.fileUploadError(error.localizedDescription)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    subject.send(completion: .failure(.unknownError))
                    return
                }
                
                do {
                    let decodedData = try self.handleHTTPResponse(response, data: data ?? Data())
                    let decodedResponse = try endpoint.decoder.decode(decodedData) as T
                    subject.send(.success(decodedResponse))
                    subject.send(completion: .finished)
                } catch {
                    print(error)
                    subject.send(completion: .failure(.fileUploadError(error.localizedDescription)))
                }
            }
            
            uploadProgressObservation = uploadTask.observe(\.countOfBytesSent) { task, _ in
                let progress = Progress(totalUnitCount: task.countOfBytesExpectedToSend)
                progress.completedUnitCount = task.countOfBytesSent
                subject.send(.progress(progress))
            }
            
            uploadTask.resume()
        } catch {
            return Fail(error: .fileUploadError(error.localizedDescription)).eraseToAnyPublisher()
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    private func handleHTTPResponse(_ response: URLResponse, data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        print("Received HTTP response: Status Code: \(httpResponse.statusCode), URL: \(httpResponse.url?.absoluteString ?? "unknown")")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "N/A"
            let httpErrorMessage = "Received HTTP error status code: \(httpResponse.statusCode). Body: \(body)"
            print(httpErrorMessage)
            throw NetworkError.httpError(httpResponse.statusCode, body)
        }
        
        if let jsonStr = String(data: data, encoding: .utf8) {
            print("Received JSON response: \(jsonStr)")
        }
        
        return data
    }
    
    func createMultipartFormData(fileURL: URL, boundary: String) throws -> Data {
        var data = Data()
        
        // Determine the correct MIME type
        let mimeType = fileURL.mimeType()
        
        // Add the file data
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        
        let fileData = try Data(contentsOf: fileURL)
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
        
        // Add the closing boundary
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return data
    }
}

extension URL {
    func mimeType() -> String {
        if let utType = UTType(filenameExtension: self.pathExtension) {
            if let mimeType = utType.preferredMIMEType {
                return mimeType
            }
        }
        return "application/octet-stream"
    }
}
