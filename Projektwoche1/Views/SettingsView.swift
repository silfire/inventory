//
//  SettingsView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties

	// TODO: Einstellungen über AppStorage/UserDefaults persistent machen
    @State private var selectedCriterion: SortCriteria = .alphabetical
    @State private var selectedDirection: SortDirection = .ascending
    @State private var showDeleteConfirmation = false
    
    // MARK: - Body
    
    var body: some View {
        Form {
            sortSection
            dataSection
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
                // TODO: Delete all data
            }
        } message: {
            Text("Diese Aktion kann nicht rückgängig gemacht werden.")
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
