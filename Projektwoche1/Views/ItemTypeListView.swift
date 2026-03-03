//
//  ItemTypeListView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct ItemTypeListView: View {
	@Environment(\.modelContext) private var context

	@Query(sort: \ItemType.title) var itemTypes : [ItemType]

	var body: some View {
		NavigationStack {
			List {
				ForEach(itemTypes) { itemType in
					Text(itemType.title)
				}
			}
			.toolbar {
				ToolbarItem {
					Button {
						// TODO: add new Item Type
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			// TODO: on Delete
			.navigationTitle("Item types")
		}
    }
}

#Preview {
    ItemTypeListView()
		.modelContainer(DataProvider.preview.container)
}
