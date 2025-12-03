//
//  DependencyContainerReqistrationType.swift
//  DependencyContainer
//
//  Created by Ahmet Öztemiz on 3.12.2025.
//

public enum DependencyContainerReqistrationType {
    case singleInstance(AnyObject)
    case closureBased(() -> Any)
}
