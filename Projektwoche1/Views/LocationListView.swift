//
//  LocationListView.swift
//  Projektwoche1
//
//  Created by Daniel Kuba on 05.03.26.
//

import SwiftUI
import SwiftData

struct LocationListView: View {
	@Environment(\.modelContext) private var context
	@Environment(\.editMode) private var editMode

	@Query(sort: \Location.name) var locations: [Location]

	var body: some View {
		NavigationStack {
			List {
				ForEach(locations) { location in
					LocationCellView(location: location)
				}
				.onDelete { indexSet in
					for index in indexSet {
						context.delete(locations[index])
					}
				}
			}
			.toolbar {
				ToolbarItem {
					EditButton()
				}
				ToolbarItem {
					Button {
						context.insert(Location(name: ""))
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.animation(.default, value: locations)
			.navigationTitle("Locations")
		}
	}


}

#Preview {
    LocationListView()
		.modelContainer(DataProvider.preview.container)
}
