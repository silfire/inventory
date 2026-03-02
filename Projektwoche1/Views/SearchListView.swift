//
//  SearchListView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct SearchListView: View {
	@Environment(\.modelContext) private var context

	@State var searchText : String = ""

	var body: some View {
		ContentUnavailableView("Search items", systemImage: "magnifyingglass")
		.searchable(
			text: $searchText,
			placement: .automatic,
			prompt: "Search items")
    }
}

#Preview {
    SearchListView()
		.modelContainer(DataProvider.preview.container)
}
