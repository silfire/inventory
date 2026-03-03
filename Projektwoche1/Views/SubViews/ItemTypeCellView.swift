//
//  ItemTypeCellView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 03.03.26.
//

import SwiftUI
import SwiftData

struct SkillItemView: View {
	@Environment(\.modelContext) private var context

	@State var itemType: ItemType

	@FocusState private var hasFocus : Bool
	@State private var showTextField : Bool = false
	@State private var input : String = ""

	var body: some View {
		HStack {
			if showTextField || itemType.title.isEmpty {
				TextField("Name eingeben", text: $input)
					.focused($hasFocus)
			} else {
				Button {
					self.input = itemType.title
					showTextField = true
				} label: {
					HStack {
						Text(itemType.title)
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
				itemType.title = input
				if context.hasChanges {
					try? context.save()
				}
				showTextField = false
			}
		}
	}

}

#Preview {
	List {
		SkillItemView(itemType: ItemType(title: "Gerät"))
			.modelContainer(DataProvider.preview.container)
	}
}
