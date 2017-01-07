//
//  Array+Random.swift
//  SimonSays
//
//  Created by Simon Støvring on 07/01/2017.
//  Copyright © 2017 Simon Støvring. All rights reserved.
//

import Foundation

extension Collection where IndexDistance == Int {
    var random: Iterator.Element? {
        guard !isEmpty else { return nil }
        let idx = Int(arc4random_uniform(UInt32(count)))
        return self[index(startIndex, offsetBy: idx)]
    }
}
