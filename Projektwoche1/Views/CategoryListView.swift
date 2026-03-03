//
//  CategoryListView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
	@Environment(\.modelContext) private var context
	@Environment(\.editMode) private var editMode

	@Query(sort: \Category.title) var categories : [Category]

	var body: some View {
		NavigationStack {
			List {
				ForEach(categories) { itemType in
					CategoryCellView(category: itemType)
				}
				.onDelete { indexSet in
					for index in indexSet {
						context.delete(categories[index])
					}
				}
			}
			.toolbar {
				ToolbarItem {
					EditButton()
				}
				ToolbarItem {
					Button {
						context.insert(Category(title: ""))
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.animation(.default, value: categories)
			.navigationTitle("Categories")
		}
    }
}

#Preview {
    CategoryListView()
		.modelContainer(DataProvider.preview.container)
}
