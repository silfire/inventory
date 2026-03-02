//
//  ItemTypeListView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct ItemTypeListView: View {
	@Environment(\.modelContext) private var context

	var body: some View {
        ContentUnavailableView("Item Types", systemImage: "tag")
    }
}

#Preview {
    ItemTypeListView()
		.modelContainer(DataProvider.preview.container)
}
