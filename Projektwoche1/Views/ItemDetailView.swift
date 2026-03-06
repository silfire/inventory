//
//  ItemDetailView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ItemDetailView: View {
	@Environment(\.modelContext) var context

    @State var item : Item
    
    @State private var selectedImage : PhotosPickerItem? = nil
    @State private var uiImage : UIImage? = nil
    
    @Query(sort: \Category.title) var categories: [Category]
	@Query(sort: \Location.name) var locations: [Location]

	@State private var selectedCategoryID : PersistentIdentifier?
	@State private var selectedLocationID : PersistentIdentifier?

    var body: some View {
        VStack {
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
                
                TextField("Title", text: $item.title)
                
                Stepper(value: $item.quantity, in: 0...100) {
                    Text("Quantity: \(item.quantity)")
                }
                
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


                DatePicker("Select date:", selection: $item.date, displayedComponents: .date)
            }
            .onAppear {
				selectedCategoryID = item.category?.id
				selectedLocationID = item.location?.id
                if let data = item.imageData {
                    uiImage = UIImage(data: data)
                }
            }
			.onChange(of: selectedCategoryID, initial: false, { _, newValue in
				item.category = categories.first { $0.id == newValue }
			})
			.onChange(of: selectedLocationID, initial: false, { _, newValue in
				item.location = locations.first { $0.id == newValue }
			})
            .onChange(of: selectedImage) { oldItem, newImage in
                Task {
                    guard let newImage else { return }
                    do {
                        if let data = try await newImage.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data) {
                                uiImage = image
                                item.imageData = data
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
			.navigationTitle(item.title)
        }
    }
}

#Preview {
	NavigationStack {
		ItemDetailView(item: Item(title: "Test", count: 1))
			.modelContainer(DataProvider.preview.container)
	}
}
