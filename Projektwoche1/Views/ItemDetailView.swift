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

	@State var item : Item

	var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
	ItemDetailView(item: Item(title: "Test", count: 1))
		.modelContainer(DataProvider.preview.container)
}
