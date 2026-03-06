//
//  StatsView.swift
//  Projektwoche1
//
//  Created by Nicolas Geyer on 05.03.26.
//


import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query(sort: \Item.title) private var items: [Item]

    var body: some View {
        VStack(spacing: 24) {
            PieCard(
                title: "Verteilung nach Kategorien",
                data: categoryDistribution
            )
            // PieCard(title: "Verteilung nach Ort", data: locationDistribution)
        }
        .padding(.vertical, 8)
    }

    private var categoryDistribution: [Slice] {
        let dict = items.reduce(into: [String: Int]()) { result, item in
            let key = item.category?.title ?? "Ohne Kategorie"
            result[key, default: 0] += item.quantity
        }
        return dict.map { Slice(label: $0.key, value: $0.value) }
            .sorted { $0.value > $1.value }
    }

    private var locationDistribution: [Slice] {
        let dict = items.reduce(into: [String: Int]()) { result, item in
			let trimmed = item.location?.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let key = trimmed.isEmpty ? "Ohne Ort" : trimmed
            result[key, default: 0] += item.quantity
        }
        return dict.map { Slice(label: $0.key, value: $0.value) }
            .sorted { $0.value > $1.value }
    }
}

struct Slice: Identifiable {
    let id = UUID()
    let label: String
    let value: Int
}

struct PieCard: View {
    let title: String
    let data: [Slice]

    private var total: Int { data.reduce(0) { $0 + $1.value } }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Text("Gesamt: \(total)")
                    .font(.subheadline)
            }

            if total == 0 {
                ContentUnavailableView("Keine Daten", systemImage: "chart.pie")
                    .frame(maxWidth: .infinity, minHeight: 220)
            } else {
                Chart(data) { slice in
                    SectorMark(
                        angle: .value("Anzahl", slice.value),
                        angularInset: 3                                                                 //"Chartstyle" Zwischenräume
                    )
                    .cornerRadius(6)
                    
                }
                .frame(height: 260)
                .chartLegend(position: .bottom, alignment: .leading)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    NavigationStack {
        StatsView()
            .modelContainer(DataProvider.preview.container)
    }
}
