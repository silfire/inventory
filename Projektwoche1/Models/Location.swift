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
    var id: UUID
    var name: String
    
    
    @Relationship(inverse: \Item.location)
    var items: [Item]
    
    init(id: UUID, name: String, items: [Item]) {
        self.id = id
        self.name = name
        self.items = items
    }
   
}
