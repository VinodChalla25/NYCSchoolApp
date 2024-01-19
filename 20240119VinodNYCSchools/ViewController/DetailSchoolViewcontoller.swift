//
//  DetailSchoolViewcontoller.swift
//  20240119VinodNYCSchools
//
//  Created by challa vinodkumarreddy on 19/01/24.
//

import UIKit



class DetailSchoolViewcontoller: UIViewController {
    
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var satCriticalReadingAvgScoreLabel: UILabel!
    @IBOutlet weak var satMathAvgScoreLabel: UILabel!
    @IBOutlet weak var satWritingAvgScoreLabel: UILabel!
    var viewModel: SchoolDataModel?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Updated UI
    private func updateUI() {
        //  if let viewModel = viewModel {
        schoolNameLabel.text = viewModel?.schoolName
        satMathAvgScoreLabel.text = "sat_math_avg_score: \(viewModel?.satMathAvgScore ?? "")"
        satWritingAvgScoreLabel.text = "sat_writing_avg_score: \(viewModel?.satWritingAvgScore ?? "")"
        satCriticalReadingAvgScoreLabel.text = "sat_critical_reading_avg_score: \(viewModel?.satCriticalReadingAvgScore ?? "")"
    }
}
    

