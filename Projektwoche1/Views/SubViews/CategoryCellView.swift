//
//  CategoryCellView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 03.03.26.
//

import SwiftUI
import SwiftData

struct CategoryCellView: View {
	@Environment(\.modelContext) private var context

	@State var category: Category

	@FocusState private var hasFocus : Bool
	@State private var showTextField : Bool = false
	@State private var input : String = ""

	var body: some View {
		HStack {
			if showTextField || category.title.isEmpty {
				TextField("Name eingeben", text: $input)
					.focused($hasFocus)
			} else {
				Button {
					self.input = category.title
					showTextField = true
				} label: {
					HStack {
						Text(category.title)
						Spacer()
					}
				}
				.tint(.primary)
			}
		}
		.onChange(of: showTextField, initial: false) { _, newValue in
			if newValue {
				hasFocus = true
			}
		}
		.onChange(of: hasFocus, initial: false) { _, newValue in
			if newValue == false {
				category.title = input
				showTextField = false
			}
		}
	}

}

#Preview {
	List {
		CategoryCellView(category: Category(title: "Gerät"))
			.modelContainer(DataProvider.preview.container)
	}
}
