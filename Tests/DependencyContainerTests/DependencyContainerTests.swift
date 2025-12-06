//
//  DependencyContainerTests.swift
//  DependencyContainer
//
//  Created by Ahmet Öztemiz on 3.12.2025.
//

import XCTest
@testable import DependencyContainer

final class DependencyContainerTests: XCTestCase {
    var sut: DependencyContainer!
    
    override func setUp() {
        super.setUp()
        sut = .init()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_whenRegisterInstanceDependency_shouldResolveInstance() {
        // Given
        let instance = SingleInstanceSampleImplementation()
        
        // When
        self.sut.register(type: .singleInstance(instance), for: SingleInstanceDependencyProtocol.self)
        let resolvedInstance = sut.resolve(type: .singleInstance, for: SingleInstanceDependencyProtocol.self)
        
        // Then
        XCTAssert(instance === resolvedInstance)
    }
    
    func test_whenRegisterClosureDependency_shouldResolveClosure() {
        // Given
        let closure: () -> ClosureDependencyImplementation = {
            ClosureDependencyImplementation()
        }
        
        // When
        self.sut.register(type: .closureBased(closure), for: ClosureDependencyProtocol.self)
        let resolvedClosure = sut.resolve(type: .closureBased, for: ClosureDependencyProtocol.self)
        
        // Then
        XCTAssert(resolvedClosure is ClosureDependencyImplementation)
    }
    
    func test_whenRegisterClosureDependencyInsideAnotherDependency_shouldResolveClosure() {
        // Given
        let closure: () -> ClosureDependencyImplementation = {
            ClosureDependencyImplementation()
        }
        self.sut.register(type: .closureBased(closure), for: ClosureDependencyProtocol.self)
        
        
        // When
        let anotherClosure: () -> AnotherClosureDependencyImplementation = {
            let resolvedClosure = self.sut.resolve(type: .closureBased, for: ClosureDependencyProtocol.self)
            return AnotherClosureDependencyImplementation(service: resolvedClosure)
        }
        self.sut.register(type: .closureBased(anotherClosure), for: AnotherClosureDependencyProtocol.self)
        let resolvedAnotherClosure = self.sut.resolve(type: .closureBased, for: AnotherClosureDependencyProtocol.self)
        
        // Then
        XCTAssert(resolvedAnotherClosure is AnotherClosureDependencyImplementation)
    }
}
