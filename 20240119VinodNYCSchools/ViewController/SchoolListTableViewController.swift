//
//  SchoolListTableViewController.swift
//  20240119VinodNYCSchools
//
//  Created by challa vinodkumarreddy on 19/01/24.
//

import UIKit

class SchoolListTableViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel = SchoolListViewModel()
    private var listData:[SchoolDataModel]?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - LoadData From API
    private func loadData() {
        showLoader(title: "Loading")
        internetIsAvailble { isAvailable in
            if isAvailable {
                Task {
                    do{
                        guard let schooldata = try await self.viewModel.getList() else {return}
                        self.listData = schooldata
                        self.tableView.reloadData()
                        self.hideLoader()
                        
                    } catch let error {
                        self.hideLoader()
                        self.showAlert(title: "", message: "Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

// MARK: - Table view data source
extension SchoolListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = listData?[indexPath.row].schoolName
        cell.detailTextLabel?.text = listData?[indexPath.row].dbn
        return cell
    }
}

// MARK: - Table view delagte
extension SchoolListTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailSchoolViewcontoller") as? DetailSchoolViewcontoller {
            if let selectedSchoolData = listData?[indexPath.row] {
                print("Selected School Name: \(selectedSchoolData.schoolName)")
                vc.viewModel = selectedSchoolData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
