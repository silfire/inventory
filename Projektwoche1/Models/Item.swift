//
//  Item.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import Foundation
import SwiftData

@Model
class Item {
    var title : String
    var count : Int
    var date: Date

    @Relationship var type: ItemType?
    
    init(title: String, count: Int = 0) {
        self.title = title
        self.count = count
        self.date = .now
        self.type = nil
    }
}
