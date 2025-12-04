//
//  ClosureDependencyTestModels.swift
//  DependencyContainer
//
//  Created by Ahmet Öztemiz on 4.12.2025.
//

protocol ClosureDependencyProtocol {
    func sampleMethod()
}

struct ClosureDependencyImplementation: ClosureDependencyProtocol {
    func sampleMethod() {
        // left as blank intentionally
    }
}

protocol AnotherClosureDependencyProtocol {
    func sampleMethod()
}

struct AnotherClosureDependencyImplementation: AnotherClosureDependencyProtocol {
    let service: ClosureDependencyProtocol
    
    init(service: ClosureDependencyProtocol) {
        self.service = service
    }
    
    func sampleMethod() {
        // left as blank intentionally
    }
}
