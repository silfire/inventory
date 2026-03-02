//
//  SettingsView.swift
//  Projektwoche1
//
//  Created by Ingo Kasprzak on 02.03.26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
		ContentUnavailableView("Settings", systemImage: "gearshape")
	}
}

#Preview {
    SettingsView()
		.modelContainer(DataProvider.preview.container)
}
