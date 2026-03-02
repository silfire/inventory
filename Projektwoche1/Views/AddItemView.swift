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

	@State private var items : Item = Item(title: "", count: 1)
	@State private var sliderValue : Double = 1
    var body: some View {
		Form {
			TextField("Name", text: $items.title)
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
			}
			Section {
				Button {
					items.count = Int(sliderValue)
					context.insert(items)
					dismiss()
				} label: {
					Text("Hinzufügen")
				}
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
