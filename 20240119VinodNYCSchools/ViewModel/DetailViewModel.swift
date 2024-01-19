//
//  DetailViewModel.swift
//  20240119VinodNYCSchools
//
//  Created by challa vinodkumarreddy on 19/01/24.
//

import Foundation

final class DetailViewModel {
    var schoolDetail: SchoolDataModel?
    init(with data:SchoolDataModel?) {
        schoolDetail = data
    }
    
    func fecthDetail() -> SchoolDataModel? {
        return schoolDetail
    }
}
