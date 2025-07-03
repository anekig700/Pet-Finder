//
//  DispatchQueue+Async.swift
//  PetFinder
//
//  Created by Kotya on 03/07/2025.
//

import Foundation

extension DispatchQueue {
    static func asyncOnMainIfNecessary(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
