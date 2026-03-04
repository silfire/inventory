//
//  ItemListView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
    @Environment(\.modelContext) private var context
    
    // TODO: Items entsprechend der Settings sortieren
    @Query(sort: \Item.title) private var items : [Item]
    
    @State private var presentAddSheet : Bool = false
    @State private var presentSettingsSheet : Bool = false
    
    // MARK: - Sort Settings
    
    @AppStorage("sortCriterion") private var sortCriterion: SortCriteria = .alphabetical
    @AppStorage("sortDirection") private var sortDirection: SortDirection = .ascending
    
    // MARK: - Computed Property
    
    private var sortedItems: [Item] {
        items.sorted { (first: Item, second: Item) -> Bool in
            let ascending = sortDirection == .ascending
            
            switch sortCriterion {
            case .alphabetical:
                return ascending ? first.title < second.title : first.title > second.title
            case .location:
                return ascending ? (first.location) < (second.location) : (first.location) > (second.location)
            case .date:
                return ascending ? first.date < second.date : first.date > second.date
            case .category:
                return ascending ? (first.category?.title ?? "") < (second.category?.title ?? "") : (first.category?.title ?? "") > (second.category?.title ?? "")
            case .amount:
                return ascending ? first.quantity < second.quantity : first.quantity > second.quantity
            }
        }
    }
    
    private var totalQuantity: Int {
        items.reduce(into: 0) { result, item in
            result += item.quantity
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            ItemDetailView(item: item)
                        } label: {
                            ItemCellView(item: item)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(items[index])
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            presentSettingsSheet.toggle()
                        } label: { Image(systemName: "gearshape")}
                    }
                    
                    ToolbarItem {
                        Button {
                            presentAddSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationTitle("Inventory")
            }
            .animation(.default, value: items)
            .sheet(isPresented: $presentAddSheet) {
                NavigationStack {
                    AddItemView()
                        .presentationDetents([.medium])
                }
            }
            .sheet(isPresented: $presentSettingsSheet) {
                NavigationStack {
                    SettingsView()
                        .presentationDetents([.medium])
                }
            }
            
            .onAppear {
                guard items.isEmpty else { return }
            }
            
            TotalInventoryView(total: totalQuantity)
                .padding(.bottom, 20)          
                .padding(.horizontal, 16)
                .allowsHitTesting(false)                                                            // TabBar bleibt klickbar
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
            
        
        
        
    }
}

#Preview {
    ItemListView()
        .modelContainer(DataProvider.preview.container)
}
