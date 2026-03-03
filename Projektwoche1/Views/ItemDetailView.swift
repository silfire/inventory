//
//  ItemDetailView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct ItemDetailView: View {
	@Environment(\.modelContext) var context

    @State var item : Item = Item(title: "", count: 1)
    
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
        }
    }
}

#Preview {
	ItemDetailView(item: Item(title: "Test", count: 1))
		.modelContainer(DataProvider.preview.container)
}
