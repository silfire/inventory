//
//  DataProvider.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import Foundation
import SwiftData

@MainActor
class DataProvider {
	static let shared : DataProvider = {
		print("SwiftData inMemory: FALSE")
		return DataProvider()
	}()

	static let preview : DataProvider = {
		let provider = DataProvider(preview: true)
		if try! provider.mainContext.fetchCount(FetchDescriptor<Item>()) == 0 {
			provider.addExamples()
		}
		return provider
	}()

	let container: ModelContainer
	var mainContext : ModelContext { return self.container.mainContext }

	private init(preview : Bool = false) {
		let schema = Schema([Item.self, Category.self])

		let config = ModelConfiguration("Inventory_Configuration", schema: schema, isStoredInMemoryOnly: preview)
		do {
			// self.container = try ModelContainer(for: schema, migrationPlan: CashualSchemaMigrationPlan.self, configurations: config)
			self.container = try ModelContainer(for: schema, configurations: [config])
			self.container.mainContext.author = "Inventory_MainContext"
			self.container.mainContext.autosaveEnabled = true
		} catch {
			fatalError("Could not initialize ModelContainer")
		}
	}

	func addExamples() {
		let book = Category(title: "Buch")
		mainContext.insert(book)
		let furniture = Category(title: "Möbel")
		mainContext.insert(furniture)
		let hardware = Category(title: "Hardware")
		mainContext.insert(Category(title: "Musik"))
		let sport = Category(title: "Sport")
		mainContext.insert(sport)

		mainContext.insert(Item(title: "Harry Potter 1", count: 1, category: book))
		mainContext.insert(Item(title: "Harry Potter 2", count: 3, category: book))
		mainContext.insert(Item(title: "Harry Potter 3", count: 1, category: book))
		mainContext.insert(Item(title: "Harry Potter 4", count: 1, category: book))
		mainContext.insert(Item(title: "Cray-1", count: 1, category: hardware))
		mainContext.insert(Item(title: "Kommode", count: 1, category: furniture))
		mainContext.insert(Item(title: "Surfbrett", count: 2, category: sport))
	}

}
