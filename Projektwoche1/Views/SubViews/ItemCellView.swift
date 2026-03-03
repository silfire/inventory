//
//  ItemCellView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 03.03.26.
//

import SwiftUI
import SwiftData

struct ItemCellView: View {
	@Environment(\.modelContext) private var context

	@State var item : Item

    var body: some View {
		HStack {
			Text(item.title)
			Spacer()
			Text("\(item.quantity)")
				.padding()
				.background(.quaternary)
				.clipShape(.circle)

		}
    }
}

#Preview {
	NavigationStack {
		List {
			ItemCellView(item: Item(title: "Brötchenkorb", count: 3))
				.modelContainer(DataProvider.preview.container)
				.listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
		}
	}
}
