//
//  ContentView.swift
//  Projektwoche1
//
//  Created by Jana Jansen on 24.01.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) var modelContext

	@Query() var inventories : [Inventory]

	var body: some View {
        NavigationStack {
			List {
				ForEach(inventories) { inventory in
					Text(inventory.title)
				}
			}
        }
        .padding()

		.onAppear {
			guard inventories.isEmpty else { return }
			modelContext.insert(Inventory(title: "Harry Potter 1", count: 1))
			modelContext.insert(Inventory(title: "Harry Potter 2", count: 1))
			modelContext.insert(Inventory(title: "Harry Potter 3", count: 1))
			modelContext.insert(Inventory(title: "Harry Potter 4", count: 1))
		}

    }
}

#Preview {

    ContentView()
		.modelContainer(for: [Inventory.self], inMemory: true)
}
