//
//  TotalItemsGlassPill.swift
//  Projektwoche1
//
//  Created by Nicolas Geyer on 03.03.26.
//


import SwiftUI

struct TotalInventoryView: View {
    let total: Int
    
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: "sum")
                    .font(.system(size: 28))
                    .padding(.horizontal, 10)
                
                Text("Dein Inventar insgesamt:")
                    .font(.headline)
            }
            
            Text("\(total)")
                .font(.title2.weight(.bold))
                .monospacedDigit()
                .padding(10)
                .overlay(
                    Capsule().strokeBorder(.red.opacity(1), lineWidth: 2)
                )
                .shadow(radius: 10, y: 5)
        }
        
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule().strokeBorder(.white.opacity(0.25), lineWidth: 1)
        )
        .shadow(radius: 10, y: 5)
    }
    
}

#Preview {
    TotalInventoryView(total: 10)
        .padding()
    
}
