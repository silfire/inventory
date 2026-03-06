# Projektwoche #1 / Inventory
## `SwiftData` & `SwiftUI`- Übungen
Eine einfache Gegenstandsverwaltung für den Haushalt 

#### Struktur der App:
Mit der App kann man Gegenstände im Haushalt verwalten. Die Gegenstände kann man frei kategorisieren.

#### View-Struktur des Codes:
- `ContentView` mit TabBar
  - `ItemListView` (Gegenstände)
    - `ItemDetailView` per NavigationLink
    - `AddItemView` per Toolbar-Button
    - `SettingsView` per Toolbar-Button
  - `CategoryListView` (Kategorien)
  - `SearchListView` (Gegenstandssuche)
  
- SubViews:
  - `ItemCellView` - View für `Item`-Models in einer `List`, z.B. im `ItemListView` oder `SearchListView`

#### Models:
- `DataProvider`: Singleton, stellt den ModelContainer als `.shared` oder `.preview` (inMemory) bereit
- `@Model` `Item` (Gegenstand)
- `@Model` `ItemType` (Kategorie)
- SortOrder: `SortCriteria`und `SortDirection` enums
