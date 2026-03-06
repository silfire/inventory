//
//  AddItemView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddItemView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var context

	@Query(sort: \Category.title) var categories: [Category]
	@Query(sort: \Location.name) var locations: [Location]

	@State private var title : String = ""
	@State private var quantity : Int = 1

	@State private var selectedDate: Date = .now
	@State private var selectedCategoryID : PersistentIdentifier?
	@State private var selectedLocationID : PersistentIdentifier?

	@State private var selectedImage : PhotosPickerItem? = nil
	@State private var uiImage : UIImage? = nil
	@State private var imageData : Data?

	@FocusState private var titleFocus : Bool

	var body: some View {
		ZStack {
			Form {
				Section {
					HStack {
						ZStack (alignment: .topTrailing) {
							Group {
								if let uiImage = uiImage {
									Image(uiImage: uiImage)
										.resizable()
										.scaledToFit()
								} else {
									Image(systemName: "photo.fill")
										.resizable()
										.foregroundStyle(.gray)
								}
							}
							.scaledToFill()
							.clipShape(RoundedRectangle(cornerRadius: 20))

							PhotosPicker(selection: $selectedImage, matching: .images) {
								Image(systemName: "pencil.circle.fill")
									.background(Color.white.clipShape(Circle()))
									.offset(x: 10, y: -10)
							}
						}
					}
				}
				.listRowBackground(Color.clear)

				TextField("Titel", text: $title).focused($titleFocus)

				Picker("Kategorie", selection: $selectedCategoryID) {
					ForEach(categories, id: \.id) { category in
						Text(category.title)
							.tag(category.id)
					}
				}
				Picker("Ort", selection: $selectedLocationID) {
					ForEach(locations, id: \.id) { location in
						Text(location.name)
							.tag(location.id)
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
					let category = categories.first { $0.id == selectedCategoryID }
					let location = locations.first { $0.id == selectedLocationID }
					let item = Item(title: title,
									count: quantity,
									category: category,
									location: location)
					item.date = selectedDate
					item.imageData = imageData
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
		.toolbar(content: {
			ToolbarItem(placement: .automatic) {
				Button {
					dismiss()
				} label: {
					Image(systemName: "xmark")
				}
			}
		})
		.onChange(of: selectedImage) { oldItem, newImage in
			Task {
				guard let newImage else { return }
				do {
					if let data = try await newImage.loadTransferable(type: Data.self) {
						if let image = UIImage(data: data) {
							uiImage = image
							imageData = data
						}
					}
				} catch {
					print(error)
				}
			}
		}
		.onAppear {
			if selectedCategoryID == nil {
				selectedCategoryID = categories.first?.id
			}
			if selectedLocationID == nil {
				selectedLocationID = locations.first?.id
			}
			titleFocus = true
		}
	}
}
#Preview {
	NavigationStack {
		AddItemView()
			.modelContainer(DataProvider.preview.container)
	}
}
