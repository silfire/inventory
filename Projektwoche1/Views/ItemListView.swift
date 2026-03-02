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

	@Query(sort: \Item.title) private var items : [Item]

	@State private var presentAddSheet : Bool = false

	var body: some View {
		NavigationStack {
			List {
				ForEach(items) { item in
					NavigationLink {
						ItemDetailView(item: item)
					} label: {
						Text(item.title)
					}

				}
				.onDelete { indexSet in
					for index in indexSet {
						context.delete(items[index])
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
		.animation(.default, value: items)
		.sheet(isPresented: $presentAddSheet) {
			NavigationStack {
				AddItemView()
					.presentationDetents([.medium])
			}
		}

		.onAppear {
			guard items.isEmpty else { return }
		}
	}
}

#Preview {
    ItemListView()
		.modelContainer(DataProvider.preview.container)
}
