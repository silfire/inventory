//
//  sortOrder.swift
//  Projektwoche1
//
//  Created by Domenik Noth on 03.03.26.
//

import Foundation

// MARK: - Sort Criteria

enum SortCriteria: String, CaseIterable {
    case alphabetical = "alphabetical"
    case location     = "location"
    case date         = "date"
    case categrory    = "category"
    case amount       = "amount"
    
    var displayName: String {
        switch self {
        case .alphabetical: return "Alphabetisch"
        case .location:     return "Ort"
        case .date:         return "Datum"
        case .categrory:    return "Kategorie"
        case .amount:       return "Betrag"
        }
    }
}

// MARK: - Sort Direction

enum SortDirection: String, CaseIterable {                      /// CaseIterable = "Gib mir alle Cases als Array"
    case ascending  = "ascending"
    case descending = "descending"
    
    var displayName: String {
        switch self {
        case .ascending:  return "Aufsteigend"
        case .descending: return "Absteigend"
        }
    }
}
