//
//  AddInventoryView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct AddInventoryView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var context

	@State private var inventory : Inventory = Inventory(title: "", count: 1)
	@State private var sliderValue : Double = 1
    var body: some View {
		Form {
			TextField("Name", text: $inventory.title)
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
					inventory.count = Int(sliderValue)
					context.insert(inventory)
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
		AddInventoryView()
			.modelContainer(for: [Inventory.self], inMemory: true)
	}
}
