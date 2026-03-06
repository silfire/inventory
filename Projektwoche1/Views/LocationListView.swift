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
    
    var body: some View {
        NavigationStack {
            List(locations) { location in
                Text(location.name)
            }
            .navigationTitle("Locations")
        }
    }
}
#Preview {
    LocationListView()
}
