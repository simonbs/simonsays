//
//  Make.swift
//  SimonSays
//
//  Created by Simon Støvring on 05/01/2017.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

protocol Make {}

extension Make where Self: Any {
    func sbs_make(make: ((Self) -> Void)? = nil) -> Self {
        make?(self)
        return self
    }
}

extension NSObject: Make {}
