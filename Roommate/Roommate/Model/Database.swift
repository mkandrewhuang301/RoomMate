//
//  Database.swift
//  Roommate
//
//  Created by Andrew Huang on 3/19/24.
//

import Foundation

final class Database: ObservableObject{
    @Published private var db: [Int:User] = [:]
    static let shared = Database()
    
}
