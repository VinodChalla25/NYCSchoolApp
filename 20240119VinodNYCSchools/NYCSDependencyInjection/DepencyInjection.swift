//
//  DepencyInjection.swift
//  20240119VinodNYCSchools
//
//  Created by challa vinodkumarreddy on 19/01/24.
//

import Foundation


///This is dependancy injection protoco for class
public protocol NYCSDIContainerProtocol {
    func register<Service>(type: Service.Type, component:Any)
    func register<Service>(type: Service.Type, builder: @escaping (NYCSDIContainerProtocol) -> Service)
    func resolve<Service>(type: Service.Type) -> Service?
    func removeAll()
}

/// Class will be used for Dependency Injection container
final class NYCSDIContainer: NYCSDIContainerProtocol {
    
    static let shared = NYCSDIContainer()
    var service: [String: Any] = [:]
    
    private init() {}
    
    func register<Service>(type: Service.Type, component: Any) {
        service["\(type)"] = component
    }
    
    func register<Service>(type: Service.Type, builder: @escaping (NYCSDIContainerProtocol) -> Service) {
        service["\(type)"] = builder
    }
    
    func resolve<Service>(type: Service.Type) -> Service? {
        if let value = service["\(type)"] as? Service {
            return value
        }
        
        if let builder = service["\(type)"] as? (NYCSDIContainerProtocol) -> Service {
            return builder(self)
        }
        
        return nil
    }
    
    func removeAll() {
        service.removeAll()
    }
}


/// Methods used for registering service in project which can used as a dependancy and have same instance
/// - Parameters:
///   - type: Type is of Service class want to regsiter
///   - component: component is of any type
public func registerService<Service>(type: Service.Type, component:Any) {
    let container = NYCSDIContainer.shared
    container.register(type: type, component: component)
}


/// Methods used for registering service in project which can used as a dependancy and have same instance
/// - Parameters:
///   - type: Type is of Service class want to regsiter
///   - builder: builder is clouure type of (NYCSDIContainerProtocol) -> Service)
public func registerService<Service>(type: Service.Type,
                         builder: @escaping (NYCSDIContainerProtocol) -> Service) {
    let container = NYCSDIContainer.shared
    container.register(type: type, builder: builder)
}


/// Method used for resolve the service
/// - Parameter type: type is of my service type
/// - Returns: It returns the registerd the Service.
public func resolveService<Service>(type: Service.Type) -> Service? {
    let container = NYCSDIContainer.shared
    return container.resolve(type: type)
}

/// Stop all service
public func removeAll() {
    NYCSDIContainer.shared.removeAll()
}
