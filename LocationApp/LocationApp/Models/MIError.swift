//
//  MIError.swift
//  LocationApp
//
//  Created by MacBook on 2022-08-08.
//

import Foundation

public struct MIError: Error {
    var status: Int?
    var title: String?
    var message: String
}
