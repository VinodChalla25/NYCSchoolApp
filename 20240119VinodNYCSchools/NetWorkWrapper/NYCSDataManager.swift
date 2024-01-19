//
//  NYCSDataManager.swift
//  20240119VinodNYCSchools
//
//  Created by challa vinodkumarreddy on 19/01/24.
//

import Foundation
import Network

protocol FetchDataService {
    func fecthSchoolDate() async throws -> [SchoolDataModel]?
}

class NYCSDataManager: FetchDataService {
    var networkManager: NYCSchoolNetWorking?
    init() {
        registerService(type: NYCSchoolNetWorking.self, component: NetworkManager())
        self.networkManager = resolveService(type: NYCSchoolNetWorking.self)
    }
    
    func fecthSchoolDate() async throws -> [SchoolDataModel]? {
        return try await networkManager?.request(url: NYCSAPIWrappers.getSchoolList.url, method: .get, headers: nil, parameters: nil)
    }
}

extension NetworkManager {
    
    func checkInternetAvailability() async throws -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        let path = try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<NWPath.Status, Error>) in
            monitor.start(queue: queue)
            monitor.pathUpdateHandler = { path in
                continuation.resume(returning: path.status)
                monitor.cancel()
            }
        }
        
        return path == .satisfied
    }
}
