//
//  APIWrappers.swift
//  20240119VinodNYCSchools
//
//  Created by challa vinodkumarreddy on 19/01/24.
//

import Foundation

enum NYCSAPIWrappers {
    case getSchoolList
    
    var baseURL: String {
        return "https://data.cityofnewyork.us/resource"
    }
    var endPoint: String {
        switch self {
        case .getSchoolList:
            return "/f9bf-2cp4.json"
        }
    }
    
    var url: String {
        return self.baseURL + self.endPoint
    }
}
