//
//  ContentView.swift
//  Projektwoche1
//
//  Created by Jana Jansen on 24.01.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var context

	@Query(sort: \Inventory.title) private var inventories : [Inventory]

	@State private var presentAddSheet : Bool = false

	var body: some View {
        NavigationStack {
			List {
				ForEach(inventories) { inventory in
					Text(inventory.title)
				}
				.onDelete { indexSet in
					for index in indexSet {
						context.delete(inventories[index])
					}
				}
			}
			.toolbar {
				ToolbarItem {
					Button {
						presentAddSheet.toggle()
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.navigationTitle("Inventory")
        }
		.animation(.default, value: inventories)
        .padding()
		.sheet(isPresented: $presentAddSheet) {
			NavigationStack {
				AddInventoryView()
					.presentationDetents([.medium])
			}
		}

		.onAppear {
			guard inventories.isEmpty else { return }
			context.insert(Inventory(title: "Harry Potter 1", count: 1))
			context.insert(Inventory(title: "Harry Potter 2", count: 1))
			context.insert(Inventory(title: "Harry Potter 3", count: 1))
			context.insert(Inventory(title: "Harry Potter 4", count: 1))
		}
    }

}

#Preview {
    ContentView()
		.modelContainer(for: [Inventory.self], inMemory: true)
}
