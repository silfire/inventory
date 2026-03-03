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
    
    @Query(sort: \Item.title) private var items : [Item]
    @State private var filterResult: [Item] = []
    @State private var searchText : String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (filterResult) { item in
					ItemCellView(item: item)
                }
            }
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: "Search items")
            .onChange(of: searchText) { _, _ in
                filterResult = items.filter {item in
                    item.title.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    }
}

#Preview {
    SearchListView()
        .modelContainer(DataProvider.preview.container)
}
