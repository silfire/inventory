//
//  AddItemView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Query var itemTypes: [ItemType]
    
    @State private var items : Item = Item(title: "", count: 1)
    @State private var sliderValue : Double = 1
    
    @State private var selectedDate: Date = .now
    @State private var selectedCategory : ItemType?
    
    var body: some View {
        Form {
            TextField("Füge ein neues Item hinzu", text: $items.title)
            
            Picker("Kategorie", selection: $items.type) {
                ForEach(itemTypes) { category in
                    Text(category.title)
                        .tag(category)
                }
            }
            .onAppear {
                if items.type == nil {
                    items.type = itemTypes.first
                }
            }
            
            DatePicker("Datum auswählen", selection: $items.date, displayedComponents: .date)
            
            VStack {
                Text("Anzahl")
                HStack {
                    Text("0")
                    Slider(value: $sliderValue, in: 0...50, step: 1, label: {
                        Text("Anzahl")
                    })
                    Text("50")
                }
                Text("\(Int(sliderValue))")
                
                Section {
                    Button {
                        items.count = Int(sliderValue)
                        items.date = selectedDate 
                        context.insert(items)
                        dismiss()
                    } label: {
                        Text("Hinzufügen")
                    }
                }
            }
            .navigationTitle("New item")
        }
    }
}
#Preview {
    NavigationStack {
        AddItemView()
            .modelContainer(DataProvider.preview.container)
    }
}
