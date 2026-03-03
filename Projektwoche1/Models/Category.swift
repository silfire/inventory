//
//  Category.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import Foundation
import SwiftData

@Model
class Category {
    var title : String

    @Relationship(inverse: \Item.category) var items: [Item] = []

    init(title: String = "") {
        self.title = title
    }
}
