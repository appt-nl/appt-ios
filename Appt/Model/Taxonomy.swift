//
//  Taxonomy.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 03/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import Foundation

class Taxonomy: Codable {
    
    var id: Int
    var count: Int
    var description: String
    var name: String
    var selected: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id
        case count
        case description
        case name
    }
}

typealias Category = Taxonomy
typealias Tag = Taxonomy

extension Array where Element == Taxonomy {
    var selected: [Element] {
        return filter { (element) -> Bool in
            element.selected
        }
    }
    var ids: [String] {
        return map { String($0.id) }
    }
    var names: [String] {
        return map { String($0.name) }
    }
}
