//
//  GridCoordinate.swift
//  GridView
//
//  Created by Corné on 19/07/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import Foundation

public struct GridCoordinate {
    public let x: Int
    public let y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension GridCoordinate: Equatable {

    public static func == (lhs: GridCoordinate, rhs: GridCoordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
