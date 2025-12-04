//
//  SingleInstanceTestModels.swift
//  DependencyContainer
//
//  Created by Ahmet Öztemiz on 4.12.2025.
//

protocol SingleInstanceDependencyProtocol: AnyObject {
    func sampleMethod()
}

final class SingleInstanceSampleImplementation: SingleInstanceDependencyProtocol {
    func sampleMethod() {
        // left as blank intentionally
    }
}
