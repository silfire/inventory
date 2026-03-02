//
//  ItemListView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
	@Environment(\.modelContext) private var context

	@Query(sort: \Item.title) private var inventories : [Item]

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
				ToolbarItem(placement: .topBarLeading) {
					Button {} label: { Image(systemName: "gearshape")}
				}

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
		.sheet(isPresented: $presentAddSheet) {
			NavigationStack {
				AddItemView()
					.presentationDetents([.medium])
			}
		}

		.onAppear {
			guard inventories.isEmpty else { return }
		}
	}
}

#Preview {
    ItemListView()
		.modelContainer(DataProvider.preview.container)
}
