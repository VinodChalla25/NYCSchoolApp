//
//  SchoolListViewModel.swift
//  20240119VinodNYCSchools
//
//   Created by challa vinodkumarreddy on 19/01/24.
//

import Foundation

final class SchoolListViewModel {
    let fetchData: FetchDataService?
    init() {
        registerService(type: FetchDataService.self, component: NYCSDataManager())
        self.fetchData = resolveService(type: FetchDataService.self)
    }
    
    func getList() async throws -> [SchoolDataModel]? {
        do {
            return try await fetchData?.fecthSchoolDate()
        } catch let error {
            throw error
        }
    }
}
