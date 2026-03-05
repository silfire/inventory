//
//  Location.swift
//  Projektwoche1
//
//  Created by Daniel Kuba on 05.03.26.
//

import Foundation
import SwiftData

@Model
class Location {
    var name: String

	@Relationship(inverse: \Item.location) var items: [Item] = []

    init(name: String) {
        self.name = name
    }
    
}
