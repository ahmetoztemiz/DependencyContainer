//
//  DependencyContainer.swift
//  DependencyContainer
//
//  Created by Ahmet Öztemiz on 3.12.2025.
//

import Foundation

public typealias DC = DependencyContainer

public final class DependencyContainer: @unchecked Sendable {
    
    public static let shared = DependencyContainer()
    
    init() {}
    
    private var singleInstanceDependencies: [ObjectIdentifier: AnyObject] = [:]
    private var closureBasedDependencies: [ObjectIdentifier: () -> Any] = [:]
    
    private let dependencyAccessQueue = DispatchQueue(
        label: "com.dependency.container.access.queue",
        attributes: .concurrent
    )
    
    public func register(type: DependencyContainerReqistrationType, for interface: Any.Type) {
        let identifier = ObjectIdentifier(interface)
        
        dependencyAccessQueue.async(flags: .barrier) {
            switch type {
            case .singleInstance(let instance):
                self.singleInstanceDependencies[identifier] = instance
            case .closureBased(let closure):
                self.closureBasedDependencies[identifier] = closure
            }
        }
    }
    
    public func resolve<Value>(type: DependencyContainerResolvingType, for interface: Value.Type) -> Value {
        var value: Value!
        let identifier = ObjectIdentifier(interface)
        
        dependencyAccessQueue.sync {
            switch type {
            case .singleInstance:
                guard let singleInstanceDependency = singleInstanceDependencies[identifier] as? Value else {
                    fatalError("Could not retrieve a dependency for given type: \(identifier)")
                }
                value = singleInstanceDependency
                
            case .closureBased:
                guard let closure = closureBasedDependencies[identifier],
                      let closureBasedDependency = closure() as? Value else {
                    fatalError("Could not retrieve closure based dependency for given type: \(identifier)")
                }
                value = closureBasedDependency
            }
        }
        
        return value
    }
}
