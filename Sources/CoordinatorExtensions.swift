//
//  CoordinatorExtensions.swift
//  CoordinatorService
//
//  Created by Douglas Alexandre Barros Taquary on 09/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import Foundation
import CoordinatorServiceInterface

public extension Coordinator {
    static var asAnyCoordinatorType: AnyCoordinatorType {
        return AnyCoordinatorType(self)
    }
}
