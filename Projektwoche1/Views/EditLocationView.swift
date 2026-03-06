//
//  EditLocationView.swift
//  Projektwoche1
//
//  Created by Daniel Kuba on 05.03.26.
//

import SwiftUI
import SwiftData

struct EditLocationView: View {
    
    @Bindable var location: Location
    
    var body: some View {
        Text("Location bearbeiten: \(location.name)")
        Form {
            TextField("Location name", text: $location.name)
        }
    }
}

#Preview {
    EditLocationView(
        location: Location(name: "Test Location")
    )
}
