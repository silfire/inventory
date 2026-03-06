//
//  LocationListView.swift
//  Projektwoche1
//
//  Created by Daniel Kuba on 05.03.26.
//

import SwiftUI
import SwiftData

struct LocationListView: View {

    @Query(sort: \Location.name) var locations: [Location]
    @State private var showAddLocation = false

    var body: some View {
        NavigationStack {
            List(locations) { location in
                NavigationLink {
                    EditLocationView(location: location)
                } label: {
                    Text(location.name)
                }
            }
            .navigationTitle("Locations")

            .toolbar {
                Button {
                    showAddLocation = true
                } label: {
                    Image(systemName: "plus")
                }
            }

            .sheet(isPresented: $showAddLocation) {
                AddLocationView()
            }
        }
    }
}
#Preview {
    LocationListView()
}
