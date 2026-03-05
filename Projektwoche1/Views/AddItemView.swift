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

	@Query(sort: \Category.title) var itemTypes: [Category]

	@State private var title : String = ""
	@State private var quantity : Int = 1

	@State private var selectedDate: Date = .now
	@State private var selectedCategoryId : PersistentIdentifier?

	@FocusState private var titleFocus : Bool

	var body: some View {
		ZStack {
			Form {
				TextField("Titel", text: $title).focused($titleFocus)

				Picker("Kategorie", selection: $selectedCategoryId) {
					ForEach(itemTypes, id: \.id) { category in
						Text(category.title)
							.tag(category.id)
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
		.toolbar(content: {
			ToolbarItem(placement: .automatic) {
				Button {
					dismiss()
				} label: {
					Image(systemName: "xmark")
				}
			}
		})
		.onAppear {
			titleFocus = true
			if selectedCategoryId == nil {
				selectedCategoryId = itemTypes.first?.id
			}
		}
	}
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Query(sort: \Category.title) var itemTypes: [Category]
    
    @State private var items : Item = Item(title: "", count: 1)
    @State private var sliderValue : Double = 1
    
    @State private var selectedDate: Date = .now
    @State private var selectedCategory : Category?
    
    @State private var selectedImage : PhotosPickerItem? = nil
    @State private var uiImage : UIImage? = nil
    
    var body: some View {
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
            
            TextField("Füge ein neues Item hinzu", text: $items.title)
            
            Picker("Kategorie", selection: $items.category) {
                ForEach(itemTypes) { category in
                    Text(category.title)
                        .tag(category)
                }
            }
            .onAppear {
                if items.category == nil {
                    items.category = itemTypes.first
                }
            }
            
            DatePicker("Datum auswählen", selection: $items.date, displayedComponents: .date)
            
            VStack {
                Text("Anzahl")
                HStack {
                    Text("0")
                    Slider(value: $sliderValue, in: 0...50, step: 1, label: {
                        Text("Anzahl")
                    })
                    Text("50")
                }
                Text("\(Int(sliderValue))")
                
                Section {
                    Button {
                        items.quantity = Int(sliderValue)
                        items.date = selectedDate 
                        context.insert(items)
                        dismiss()
                    } label: {
                        Text("Hinzufügen")
                    }
                }
            }
            .navigationTitle("New item")
        }
        .onChange(of: selectedImage) { oldItem, newImage in
            Task {
                guard let newImage else { return }
                do {
                    if let data = try await newImage.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            uiImage = image
                            items.imageData = data
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
#Preview {
	NavigationStack {
		AddItemView()
			.modelContainer(DataProvider.preview.container)
	}
}
