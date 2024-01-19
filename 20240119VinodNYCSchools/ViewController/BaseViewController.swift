//
//  BaseViewController.swift
//  20240119VinodNYCSchools
//
// Created by challa vinodkumarreddy on 19/01/24.
//

import UIKit

open class BaseViewController: UIViewController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var loaderView: LoaderView!
    
    // MARK: - View Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        loaderView = LoaderView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.isHidden = true
        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loaderView.topAnchor.constraint(equalTo: view.topAnchor),
            loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showLoader(title: String? = nil) {
        loaderView.startAnimating(withTitle: title)
        loaderView.isHidden = false
    }
    
    func hideLoader() {
        loaderView.stopAnimating()
        loaderView.isHidden = true
    }
  
    func internetIsAvailble(completion: @escaping (Bool) -> Void){
        Task {
            do {
                if try await NetworkManager.shared.checkInternetAvailability() {
                    completion(true)
                }else {
                    showAlert(title: "", message: "Internet is not available")
                    completion(false)
                }
            }catch {
                print("Error checking internet availability: \(error.localizedDescription)")
                completion(true)
            }
        }
    }
    
    public func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                //Nothing to do
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public func showAlert(title: String, message: String, buttonTitle: String, buttonAction: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Handle cancel action
            print("Cancel button tapped")
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            // Handle confirm action
            print("Ok button tapped")
            buttonAction?()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
}

class LoaderView: UIView {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .blue
        return indicator
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(withTitle title: String?) {
        activityIndicator.startAnimating()
        titleLabel.text = title
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        titleLabel.text = nil
    }
}

