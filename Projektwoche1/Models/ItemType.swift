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

	init(title: String = "") {
		self.title = title
	}
}
