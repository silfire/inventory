//
//  ItemListView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

/// A view that displays the inventory as a list with sorting and quick actions.
struct ItemListView: View {
    /// SwiftData model context used for create/update/delete operations.
    @Environment(\.modelContext) private var context

    // The raw items fetched from SwiftData; we apply custom sorting below based on user settings.
    /// Live query of items from the model container. The base sort is by title; UI can re-sort as needed.
    @Query(sort: \Item.title) private var items : [Item]

    /// Sheet presentation state for Add and Settings views.
    @State private var presentAddSheet : Bool = false
    @State private var presentSettingsSheet : Bool = false
    
    /// Persisted user preferences that define how the list should be sorted.
    @AppStorage("sortCriterion") private var sortCriterion: SortCriteria = .alphabetical
    @AppStorage("sortDirection") private var sortDirection: SortDirection = .ascending

    /// Items sorted according to the current user preferences (criterion + direction).
    private var sortedItems: [Item] {
        items.sorted { (first: Item, second: Item) -> Bool in
            // Convenience flag to flip comparisons based on chosen direction.
            let ascending = sortDirection == .ascending
            
            // Compare two items using the selected criterion; stable, deterministic ordering per case.
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
            // Main navigation container for the list and its detail destinations.
            NavigationStack {
                // Inventory list. Rows navigate to a detail view when tapped.
                List {
                    ForEach(sortedItems) { item in
                        NavigationLink {
                            ItemDetailView(item: item)
                        } label: {
                            ItemCellView(item: item)
                        }
                    }
                    // Support swipe-to-delete to remove items from the model.
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(items[index])
                        }
                    }
                    // Tighter vertical spacing and standard horizontal padding for each row.
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                // Top bar actions: open settings and add a new item.
                .toolbar {
                    // Settings button: opens sorting and other preferences.
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            presentSettingsSheet.toggle()
                        } label: { Image(systemName: "gearshape")}
                    }
                    
                    // Add button: presents the sheet to create a new item.
                    ToolbarItem {
                        Button {
                            presentAddSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                // Localized navigation title for the inventory list.
                .navigationTitle("Liste der Inventare")
            }
            // Animate list updates when the underlying data changes.
            .animation(.default, value: items)
            // Sheet for adding a new item.
            .sheet(isPresented: $presentAddSheet) {
                NavigationStack {
                    AddItemView()
                    // Present at a medium height for a focused form.
                        .presentationDetents([.large])
                }
            }
            // Sheet for adjusting app settings (including sort preferences).
            .sheet(isPresented: $presentSettingsSheet) {
                NavigationStack {
                    SettingsView()
                    // Present settings in a medium detent for quick adjustments.
                        .presentationDetents([.large])
                }
            }
            
            // Perform any first-launch setup here if needed.
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
