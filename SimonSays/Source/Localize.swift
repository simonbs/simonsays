//
//  Localize.swift
//  SimonSays
//
//  Created by Simon Støvring on 05/01/2017.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

public typealias LazyVarArgClosure = (Void) -> CVarArg

public func localize(_ key: String) -> String {
    return localize(key, tableName: nil)
}

public func localize(_ key: String, tableName: String?, comment: String = "") -> String {
    return NSLocalizedString(key, tableName: tableName, comment: comment)
}

public func localize(_ key: String, _ args: [CVarArg?]) -> String {
    if args.count == 0 {
        return NSLocalizedString(key, comment: "")
    }
    
    return withVaList(args.flatMap({ $0 })) { (pointer: CVaListPointer) -> String in
        return NSString(format: localize(key), arguments: pointer) as String
    }
}
