//
//  NYCSchoolNetWorking.swift
//  20240119VinodNYCSchools
//
//  Created by challa vinodkumarreddy on 19/01/24.
//

import Foundation

public enum RequestType: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case requestFailed
    case invalidResponse
    case dataParsingFailed
    case responseError(statusCode: String, decription: String)
    // Add more error cases as needed
}

struct EmptyModel: Codable {
    
}

struct ExperienceErrorModel: Codable {
    var code: Int?
    var message: String?
    var stack: String?
    
    func consolidateErrors(for response: HTTPURLResponse?) async throws {
        guard let response = response else { throw NetworkError.requestFailed }
        
        if !(200...299).contains(response.statusCode), let _ = code {
            throw NetworkError.responseError(statusCode: "\(code ?? 0)", decription: message ?? "")
        }
        guard 200...299 ~= response.statusCode else{ throw NetworkError.responseError(statusCode: "\(response.statusCode)", decription: message ?? "") }
    }
}

public protocol NYCSchoolNetWorking {
    
    /// Request
    /// - Parameters:
    ///   - url: The URL String
    ///   - method: HTTP method
    ///   - headers: HTTP headers
    ///   - parameters: The Body Parameters for the request
    /// - Returns: Generic Any type
    func request<T: Codable>(url: String, method: RequestType, headers: [String: String]?, parameters: [String: Any]?) async throws -> T?
}


class NetworkManager: NYCSchoolNetWorking {
    static let shared = NetworkManager()
    
    init() {
        // Private initializer to enforce singleton pattern
    }
    
    func request<T: Codable>(url: String, method: RequestType, headers: [String: String]?, parameters: [String: Any]?) async throws -> T? {
        guard let url = URL(string: url) else { throw NetworkError.requestFailed }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        // Set headers if provided
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("*******************************************")
        
        // Set parameters if provided
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        // Log the URL and parameters
        print("Request URL:", url)
        print("Request Method:", method.rawValue)
        print("Request Headers:", request.allHTTPHeaderFields ?? [:])
        if let requestBody = request.httpBody, let requestBodyString = String(data: requestBody, encoding: .utf8) {
            print("Request Body:", requestBodyString)
        }
        print("*******************************************")
        let (data, response) = try await URLSession.shared.data(for: request)
        print("Response:*******************************************")
        
        // Log the response details
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code:", httpResponse.statusCode)
            print("Response Headers:", httpResponse.allHeaderFields)
        }
        if let responseBody = String(data: data, encoding: .utf8) {
            print("Response Body:", responseBody)
        }
        print("*******************************************")
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        var model = ExperienceErrorModel()
        model = (try? JSONDecoder().decode(ExperienceErrorModel.self,from: data)) ?? ExperienceErrorModel()
        try await model.consolidateErrors(for: httpResponse)
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        }catch _ {
            print("DATA PARSING FAILED")
            throw NetworkError.dataParsingFailed
        }
    }
    
}
