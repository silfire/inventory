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
		let schema = Schema([Item.self])

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
		mainContext.insert(Item(title: "Harry Potter 1", count: 1))
		mainContext.insert(Item(title: "Harry Potter 2", count: 1))
		mainContext.insert(Item(title: "Harry Potter 3", count: 1))
		mainContext.insert(Item(title: "Harry Potter 4", count: 1))
	}

}
