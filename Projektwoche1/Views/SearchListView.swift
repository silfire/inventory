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
                .onDelete(perform: deleteItems)
				.listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .navigationTitle("Items Details")
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: "Search items")
            .onChange(of: searchText, initial: true) { _, newValue in
				guard !newValue.isEmpty else {
					filterResult = items
					return
				}
                filterResult = items.filter {item in
                    item.title.localizedCaseInsensitiveContains(newValue)
                }
            }
        }
        
        
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = filterResult[index]
            context.delete(item)
            
        }
    }
}

#Preview {
    SearchListView()
        .modelContainer(DataProvider.preview.container)
}
