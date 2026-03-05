//
//  SettingsView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties

	
    @AppStorage("sortCriterion") private var selectedCriterion: SortCriteria = .alphabetical
    @AppStorage("sortDirection") private var selectedDirection: SortDirection = .ascending
    @State private var showDeleteConfirmation = false
    
    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss
    /// @Environment = "Gib mir automatisch Zugriff auf System-Features" hier löschen
    @Environment(\.modelContext) private var context
    ///
    


    // MARK: - Body
    
    var body: some View {
        Form {
            sortSection
            dataSection
        } // Fertig Button zum schließen
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Fertig") {
                    dismiss()
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
    // MARK: - Sort Section
    
    private var sortSection: some View {
        Section {
            // Picker für Sortier-Kriterium
            Picker("Sortieren nach", selection: $selectedCriterion) {
                ForEach(SortCriteria.allCases, id: \.self) { criterion in
                    Text(criterion.displayName).tag(criterion)
                }
            }
            
            // Picker für Richtung
            Picker("Reihenfolge", selection: $selectedDirection) {
                ForEach(SortDirection.allCases, id: \.self) { direction in
                    Text(direction.displayName).tag(direction)
                }
            }
        } header: {
            Text("Sortierung")
        }
		// TODO: Toolbar-Button, um Einstellungen wieder zu schliessen
    }
    
    // MARK: - Data Section
    
    private var dataSection: some View {
        Section {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label("Alle Daten löschen", systemImage: "trash")
            }
        } header: {
            Text("Daten")
        }
        .alert("Alle Daten löschen?", isPresented: $showDeleteConfirmation) {
            Button("Abbrechen", role: .cancel) { }
            Button("Löschen", role: .destructive) {
                deleteAllItems()
            }
        } message: {
            Text("Diese Aktion kann nicht rückgängig gemacht werden.")
        }
    }
    
    // MARK: - Funktionen
    ///  DO versuch's, TRY kann's crashen, CATCH fang's auf!"
    private func deleteAllItems() {
        do {                                                    //  do = "Versuch's"
            try context.delete(model: Item.self)               //  try = "Das hier kann scheitern"
        } catch {                                             //  catch = "Falls es scheitert, mach das"
            print("Fehler beim Löschen der Daten: \(error)")
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingsView()
            .modelContainer(DataProvider.preview.container)
    }
}
