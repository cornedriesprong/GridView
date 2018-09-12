//
//  Touch.swift
//  GridView
//
//  Created by Corné on 19/03/2018.
//  Copyright © 2018 CP3. All rights reserved.
//

import Foundation

struct Touch {
    var index: Int
    var touch: UITouch
    var coordinate: GridCoordinate
}

extension Touch: Equatable {

    static func ==(lhs: Touch, rhs: Touch) -> Bool {
        return lhs.index == rhs.index &&
            lhs.touch == rhs.touch &&
            lhs.coordinate == rhs.coordinate
    }
}

extension Touch: Hashable {

    var hashValue: Int {
        return index.hashValue
    }
}
