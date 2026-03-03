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
    var quantity : Int
    var date: Date

    @Relationship var category: Category?
    
	init(title: String, count: Int = 0, category: Category? = nil) {
        self.title = title
        self.quantity = count
        self.date = .now
        self.category = category
    }
}
