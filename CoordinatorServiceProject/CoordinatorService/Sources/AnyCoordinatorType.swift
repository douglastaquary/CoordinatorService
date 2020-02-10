//
//  AnyCoordinatorType.swift
//  CoordinatorService
//
//  Created by Douglas Alexandre Barros Taquary on 09/02/20.
//


import Foundation
import Coordina

/// A type-erased container of the metatype of a `Route`.
public final class AnyCoordinatorType {
    public let metatype: Any
    public let decode: (JSONDecoder, Data) throws -> Route

    public init<T: Coo>(_ routeType: T.Type) {
        self.metatype = routeType
        decode = { decoder, data in
            try decoder.decode(T.self, from: data)
        }
    }
}
