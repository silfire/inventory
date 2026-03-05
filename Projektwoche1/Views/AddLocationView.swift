//
//  AddLocationView.swift
//  Projektwoche1
//
//  Created by Daniel Kuba on 05.03.26.
//

import SwiftUI

struct AddLocationView: View {
    
    @Environment(\.modelContext) private var context
    @State private var name = ""
    
    var body: some View {
        Form {
            TextField("Location name", text: $name)
            
            Button("Save") {
                let newLocation = Location(name: name)
                context.insert(newLocation)
            }
        }
    }
}

#Preview {
    AddLocationView()
}
