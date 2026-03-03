//
//  ItemType.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import Foundation
import SwiftData

@Model
class ItemType {
    var title : String

    @Relationship(inverse: \Item.type) var items: [Item] = []

    init(title: String = "") {
        self.title = title
    }
}
