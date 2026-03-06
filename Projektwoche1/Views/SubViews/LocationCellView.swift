//
//  LocationCellView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 06.03.26.
//

import SwiftUI
import SwiftData

struct LocationCellView: View {
	@Environment(\.modelContext) private var context

	@State var location: Location

	@FocusState private var hasFocus : Bool
	@State private var showTextField : Bool = false
	@State private var input : String = ""

	var body: some View {
		HStack {
			if showTextField || location.name.isEmpty {
				TextField("Name eingeben", text: $input)
					.focused($hasFocus)
			} else {
				Button {
					self.input = location.name
					showTextField = true
				} label: {
					HStack {
						Text(location.name)
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
				location.name = input
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
