//
//  CoordinatorService.swift
//  CoordinatorService
//
//  Created by Douglas Alexandre Barros Taquary on 09/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import Foundation
import CoordinatorServiceInterface
import UIKit

public final class CoordinatorService: CoordinatorServiceProtocol, CoordinatorServiceRegistrationProtocol {

    let store: StoreInterface
    let failureHandler: () -> Void

    private(set) var registeredCoordinators = [String: (AnyCoordinatorType, CoordinatorHandler)]()

    public init(
        store: StoreInterface? = nil,
        failureHandler: @escaping () -> Void = { preconditionFailure() }
    ) {
        self.store = store ?? Store()
        self.failureHandler = failureHandler
        register(dependency: self, forType: CoordinatorServiceProtocol.self)
    }

    public func register<T>(dependency: Dependency, forType metaType: T.Type) {
        store.register(dependency, forMetaType: metaType)
    }

    public func register(coordinatorHandler: CoordinatorHandler) {
        coordinatorHandler.coordinators .forEach {
            registeredCoordinators[$0.identifier] = ($0.asAnyCoordinatorType, coordinatorHandler)
        }
    }

    public func navigationController<T: Feature>(
        withInitialFeature feature: T.Type
    ) -> UINavigationController {
        let rootViewController = AnyFeature(feature).build(store, nil)
        return UINavigationController(rootViewController: rootViewController)
    }

    public func navigate(
        toCoordinator coordinator: Coordinator,
        fromView viewController: UIViewController,
        presentationStyle: PresentationStyle,
        animated: Bool
    ) {
        guard let handler = handler(forCoordinator: coordinator) else {
            failureHandler()
            return
        }
        
        let newVC = handler.destination(
            forCoordinator: coordinator,
            fromViewController: viewController
        ).build(store, coordinator)
        presentationStyle.present(
            viewController: newVC,
            fromViewController: viewController,
            animated: animated
        )
    }

    func handler(forCoordinator coordinator: Coordinator) -> CoordinatorHandler? {
        let coordinatorIdentifier = type(of: coordinator).identifier
        return registeredCoordinators[coordinatorIdentifier]?.1
    }
}

extension CoordinatorService: CoordinatorServiceAnyCoordinatorDecodingProtocol {
    public func decodeAnyCoordinator(fromDecoder decoder: Decoder) throws -> (Coordinator, String) {
        let container = try decoder.singleValueContainer()
        let identifier = try container.decode(String.self)

        guard let coordinatorString = CoordinatorString(fromString: identifier) else {
            throw CoordinatorDecodingError.failedToParseCoordinatorString
        }

        guard let coordinatorType = registeredCoordinators[coordinatorString.scheme]?.0 else {
            throw CoordinatorDecodingError.unregisteredCoordinator
        }

        do {
            let value = try coordinatorType.decode(JSONDecoder(), coordinatorString.parameterData)
            return (value, coordinatorString.originalString)
        } catch {
            throw error
        }
    }

    public enum CoordinatorDecodingError: Swift.Error {
        case unregisteredCoordinator
        case failedToParseCoordinatorString
    }
}
