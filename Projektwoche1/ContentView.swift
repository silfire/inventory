//
//  ContentView.swift
//  Projektwoche1
//
//  Created by Jana Jansen on 24.01.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var context

	@Query(sort: \Item.title) private var inventories : [Item]

	@State private var presentAddSheet : Bool = false

	var body: some View {
		TabView {
			Tab("Items", systemImage: "house") {
				ItemListView()
			}

			Tab("Types", systemImage: "tag") {
				CategoryListView()
			}
			Tab(role: .search) {
				SearchListView()
			}
		}
    }
}

#Preview {
    ContentView()
		.modelContainer(DataProvider.preview.container)
}
