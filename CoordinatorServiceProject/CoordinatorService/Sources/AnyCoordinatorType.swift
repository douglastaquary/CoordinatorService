//
//  AnyCoordinatorType.swift
//  CoordinatorService
//
//  Created by Douglas Alexandre Barros Taquary on 09/02/20.
//


import Foundation

/// A type-erased container of the metatype of a `Route`.
public final class AnyRouteType {
    public let metatype: Any
    public let decode: (JSONDecoder, Data) throws -> Route

    public init<T: Route>(_ routeType: T.Type) {
        self.metatype = routeType
        decode = { decoder, data in
            try decoder.decode(T.self, from: data)
        }
    }
}
