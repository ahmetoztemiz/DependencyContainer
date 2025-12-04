//
//  DependencyContainerTests.swift
//  DependencyContainer
//
//  Created by Ahmet Öztemiz on 3.12.2025.
//

import XCTest
@testable import DependencyContainer

final class DependencyContainerTests: XCTestCase {
    func test_whenRegisterInstanceDependency_shouldResolveInstance() {
        // Given
        let instance = SingleInstanceSampleImplementation()
        
        // When
        DC.shared.register(type: .singleInstance(instance), for: SingleInstanceDependencyProtocol.self)
        let resolvedInstance = DC.shared.resolve(type: .singleInstance, for: SingleInstanceDependencyProtocol.self)
        
        // Then
        XCTAssert(instance === resolvedInstance)
    }
    
    func test_whenRegisterClosureDependency_shouldResolveClosure() {
        // Given
        let closure: () -> ClosureDependencyImplementation = {
            ClosureDependencyImplementation()
        }
        
        // When
        DC.shared.register(type: .closureBased(closure), for: ClosureDependencyProtocol.self)
        let resolvedClosure = DC.shared.resolve(type: .closureBased, for: ClosureDependencyProtocol.self)
        
        // Then
        XCTAssert(resolvedClosure is ClosureDependencyImplementation)
    }
    
    func test_whenRegisterClosureDependencyInsideAnotherDependency_shouldResolveClosure() {
        // Given
        let closure: () -> ClosureDependencyImplementation = {
            ClosureDependencyImplementation()
        }
        DC.shared.register(type: .closureBased(closure), for: ClosureDependencyProtocol.self)
        
        
        // When
        let anotherClosure: () -> AnotherClosureDependencyImplementation = {
            let resolvedClosure = DC.shared.resolve(type: .closureBased, for: ClosureDependencyProtocol.self)
            return AnotherClosureDependencyImplementation(service: resolvedClosure)
        }
        DC.shared.register(type: .closureBased(anotherClosure), for: AnotherClosureDependencyProtocol.self)
        let resolvedAnotherClosure = DC.shared.resolve(type: .closureBased, for: AnotherClosureDependencyProtocol.self)
        
        // Then
        XCTAssert(resolvedAnotherClosure is AnotherClosureDependencyImplementation)
    }
}
