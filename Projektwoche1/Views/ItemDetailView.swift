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

    @State var item : Item = Item(title: "", count: 1)
    
    @State private var selectedImage : PhotosPickerItem? = nil
    @State private var uiImage : UIImage? = nil
    
    // TODO: ItemType verbinden
    @State var itemCategory: String = "Books"

	// TODO: ItemType Model für Kategorien verwenden
    let categories: [String] = ["Books", "Electronics", "Clothing"]

    
    var body: some View {
        VStack {
            Text(item.title)
                .font(.largeTitle)
                .bold(true)
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
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                PhotosPicker(selection: $selectedImage, matching: .images) {
                                }
                            )
                        }
                    }
                }
                
                TextField("Title", text: $item.title)
                Stepper(value: $item.quantity, in: 0...100) {
                    Text("Quantity: \(item.quantity)")
                }
                Picker("Category", selection: $itemCategory) {
                    ForEach(categories, id: \.self) {
                        category in Text(category).tag(category)
                    }
                }
            }
            .onChange(of: selectedImage) { oldItem, newImage in
                Task {
                    guard let newImage else { return }
                    
                    do {
                        if let data = try? await newImage.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data) {
                                uiImage = image
                            }
                        }
                    } catch {
                        print(error)
                    }

                }
            }
        }
    }
}

#Preview {
	ItemDetailView(item: Item(title: "Test", count: 1))
		.modelContainer(DataProvider.preview.container)
}
