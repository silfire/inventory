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
//            PieCard(
//                title: "Verteilung nach Ort",
//                data: locationDistribution
//            )
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

//    private var locationDistribution: [Slice] {
//        let dict = items.reduce(into: [String: Int]()) { result, item in
//			let trimmed = item.location?.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//            let key = trimmed.isEmpty ? "Ohne Ort" : trimmed
//            result[key, default: 0] += item.quantity
//        }
//        return dict.map { Slice(label: $0.key, value: $0.value) }
//            .sorted { $0.value > $1.value }
//    }
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
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("Gesamt: \(total)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if total == 0 {
                ContentUnavailableView("Keine Daten", systemImage: "chart.pie")
                    .frame(maxWidth: .infinity, minHeight: 220)
            } else {
                Chart(data) { slice in
                    SectorMark(
                        angle: .value("Anzahl", slice.value),
                        angularInset: 3
                    )
                    .cornerRadius(6)
                    .foregroundStyle(by: .value("Kategorie", slice.label))
                }
                .frame(height: 260)
                .chartLegend(.hidden)

                VStack(spacing: 10) {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index, slice in
                        HStack(spacing: 12) {
                            Circle()                                                                // Farbkreis
                                .fill(chartColor(for: index))
                                .frame(width: 12, height: 12)

                            Text(slice.label)                                                       // Label
                                .lineLimit(1)

                            Spacer()

                            Text("\(slice.value)")                                                  // Anzahl
                                .foregroundStyle(.secondary)

                            Text("\(percentage(for: slice))%")                                      // Prozent
                                .fontWeight(.semibold)
                                .frame(width: 44, alignment: .trailing)
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Helpers

    private func percentage(for slice: Slice) -> Int {
        guard total > 0 else { return 0 }
        return Int(round((Double(slice.value) / Double(total)) * 100))
    }

    private func chartColor(for index: Int) -> Color {
        let colors: [Color] = [
            .blue, .green, .orange, .purple, .pink, .teal, .yellow, .red, .mint, .indigo
        ]
        return colors[index % colors.count]
    }
}

#Preview {
    NavigationStack {
        StatsView()
            .modelContainer(DataProvider.preview.container)
    }
}
