//
//  Projektwoche1App.swift
//  Projektwoche1
//
//  Created by Jana Jansen on 24.01.25.
//

import SwiftUI
import SwiftData

@main
struct Projektwoche1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(DataProvider.shared.container)
    }
}
