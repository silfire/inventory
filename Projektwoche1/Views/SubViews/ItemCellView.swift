//
//  ItemCellView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 03.03.26.
//

import SwiftUI
import SwiftData

struct ItemCellView: View {
	static let imageHeight : CGFloat = 34
	@Environment(\.modelContext) private var context

	@State var item : Item

    var body: some View {
		HStack {
			if let data = item.imageData, let uiImage = UIImage(data: data) {
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFill()
					.frame(width: ItemCellView.imageHeight, height: ItemCellView.imageHeight)
					.clipShape(.circle)
			} else {
				Spacer()
					.frame(width: ItemCellView.imageHeight, height: ItemCellView.imageHeight)

			}
			Text(item.title)
			Spacer()
			Text("\(item.quantity)")
				.frame(width: 34, height: 34)
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
