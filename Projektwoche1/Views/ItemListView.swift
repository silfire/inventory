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
    @AppStorage("viewMode") private var viewMode: ViewMode = .list
    
    @State private var path: [Item] = []
    
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
				return ascending ? (first.location?.name ?? "") < (second.location?.name ?? "") : (first.location?.name ?? "") > (second.location?.name ?? "")
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
    // MARK: - Gruppen Sortierung
    private var groupedByCategory: [(key: String, value: [Item])] {
        let grouped = Dictionary(grouping: sortedItems) { $0.category?.title ?? "Ohne Kategorie" }
        return grouped.sorted { $0.key < $1.key }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main navigation container for the list and its detail destinations.
            NavigationStack(path: $path) {
                Group {
                    if viewMode == .list {
                        List {
                            ForEach(sortedItems) { item in
                                NavigationLink(value: item) {
                                    ItemCellView(item: item)
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    context.delete(sortedItems[index])
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        }
                    } else {
                        List {
                            ForEach(groupedByCategory, id: \.key) { category, items in
                                Section(header: Text(category)) {
                                    ForEach(items) { item in
                                        NavigationLink {
                                            ItemDetailView(item: item)
                                        } label: {
                                            ItemCellView(item: item)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            // View Mode Buttons
                            Button {
                                viewMode = .list
                            } label: {
                                Label(ViewMode.list.displayName,
                                      systemImage: ViewMode.list.icon)
                            }
                            
                            Button {
                                viewMode = .grouped
                            } label: {
                                Label(ViewMode.grouped.displayName,
                                      systemImage: ViewMode.grouped.icon)
                            }
                            
                            Divider()
                            
                            // Settings Button
                            Button {
                                presentSettingsSheet.toggle()
                            } label: {
                                Label("Einstellungen", systemImage: "gearshape")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            presentAddSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                // Localized navigation title for the inventory list.
                .navigationTitle("Inventar")
                .navigationDestination(for: Item.self) { item in
                    ItemDetailView(item: item)
                }
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
            
            if path.isEmpty {
                TotalInventoryView(total: totalQuantity)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 16)
                    .allowsHitTesting(true)
            }
        }
    }
}

#Preview {
    ItemListView()
        .modelContainer(DataProvider.preview.container)
}
