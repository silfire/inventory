//
//  AddItemView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var context

	@Query(sort: \Category.title) var itemTypes: [Category]

	@State private var title : String = ""
	@State private var quantity : Int = 1

	@State private var selectedDate: Date = .now
	@State private var selectedCategoryId : PersistentIdentifier?

	var body: some View {
		ZStack {
			Form {
				TextField("Titel", text: $title)

				Picker("Kategorie", selection: $selectedCategoryId) {
					ForEach(itemTypes, id: \.id) { category in
						Text(category.title)
							.tag(category.id)
					}
				}
				.onAppear {
					if selectedCategoryId == nil {
						selectedCategoryId = itemTypes.first?.id
					}
				}

				DatePicker("Datum auswählen", selection: $selectedDate, displayedComponents: .date)

				Stepper(value: $quantity, in: 0...1000) {
					HStack {
						Text("Anzahl")
						Spacer()
						Text("\(quantity)")
					}
				}

				Section {} footer: {
					Spacer().frame(height: 20)
				}
			}
			VStack {
				Spacer()
				Button {
					let category = itemTypes.first { $0.id == selectedCategoryId }
					let item = Item(title: title,
									count: quantity,
									category: category)
					item.date = selectedDate
					context.insert(item)
					dismiss()
				} label: {
					Label("Hinzufügen", systemImage: "plus")
				}
				.controlSize(.large)
				.buttonStyle(.bordered)
			}
		}
		.navigationTitle("New item")
	}
}
#Preview {
	NavigationStack {
		AddItemView()
			.modelContainer(DataProvider.preview.container)
	}
}
