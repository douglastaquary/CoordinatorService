//
//  CoordinatorString.swift
//  CoordinatorService
//
//  Created by Douglas Alexandre Barros Taquary on 09/02/20.
//  Copyright © 2020 Douglas Taquary. All rights reserved.
//

import Foundation
import CoordinatorServiceInterface

public struct CoordinatorString {

    public let scheme: String
    public let parameterDict: [String: Any]
    public let parameterData: Data
    public let originalString: String

    public init?(fromString coordinatorString: String) {

        self.originalString = coordinatorString

        var schemeString = ""
        var runnerIndex = coordinatorString.startIndex

        while runnerIndex != coordinatorString.endIndex && coordinatorString[runnerIndex] != "|" {
            schemeString.append(coordinatorString[runnerIndex])
            runnerIndex = coordinatorString.index(after: runnerIndex)
        }

        if runnerIndex == coordinatorString.endIndex || coordinatorString[runnerIndex] != "|" {
            return nil
        }

        self.scheme = schemeString

        runnerIndex = coordinatorString.index(after: runnerIndex)

        if runnerIndex == coordinatorString.endIndex {
            return nil
        }

        let parameterString = coordinatorString[runnerIndex...]

        guard let parameterData = parameterString.data(using: .utf8) else {
            return nil
        }

        do {
            let json = try JSONSerialization.jsonObject(with: parameterData, options: [])
            guard let parameterDict = json as? [String: Any] else {
                return nil
            }
            self.parameterDict = parameterDict
            self.parameterData = parameterData
        } catch {
            return nil
        }
    }
}

extension CoordinatorString: Hashable {
    public static func == (lhs: CoordinatorString, rhs: CoordinatorString) -> Bool {
        return lhs.originalString == rhs.originalString
    }

    public func hash(into hasher: inout Hasher) {
        originalString.hash(into: &hasher)
    }
}
