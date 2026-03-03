# Projektwoche #1 / Inventory
## `SwiftData` & `SwiftUI`- Übungen
Eine einfache Gegenstandsverwaltung für den Haushalt 

#### Aktuelle Aufgabenverteilung:
- __Domenik__: `SettingsView`
- __Kevin__: `ItemDetailView`
- __Daniel__: `SearchListView`
- __Nicolas__: UML, Struktur, Klassifizierungen
- __Ingo__: Basis-Projektcode und -pflege, sowie Feinschliff

#### Offene ToDos:
- `@Relationship` ItemType 1->∞ Item
- `ItemTypes` anlegen und ändern
- Views an Buttons und Navigation anbinden
- Bilder/Foto Property zu `Item` hinzufügen
- Bilder verwaltbar machen
- Anzeige der Summe aller Gegenstände im `ItemListView`
- Übersicht optional, also z.b. per Toolbar-Button, nach Kategorien sortieren

#### Vorschläge und Ideen
- zusätzliches 1:∞ Model für den Lagerort, also sowas wie "Wohnzimmer", "Küche",…
- Statistik-Dashboard mit Kreisdiagramm, um Verteilung der Gegenstände nach Kategorien anzuzeigen
- Schwebende "Liquid Glass" Bedienelemente

#### Struktur der App:
Mit der App kann man Gegenstände im Haushalt verwalten. Die Gegenstände kann man frei kategorisieren.

#### View-Struktur des Codes:
- `ContenView` mit TabBar
  - `ItemListView` (Gegenstände)
    - `ItemDetailView` per NavigationLink
    - `AddItemView` per Toolbar-Button
    - `SettingsView` per Toolbar-Button
  - `ÌtemTypeListView` (Kategorien)
  - `SearchListView` (Gegenstandssuche)
  
- SubViews:
  - `ItemCellView` - View für `Item`-Models in einer `List`, z.B. im `ItemListView` oder `SearchListView`

#### Models:
- `DataProvider`: Singleton, stellt den ModelContainer als `.shared` oder `.preview` (inMemory) bereit
- `@Model` `Item` (Gegenstand)
- `@Model` `ItemType` (Kategorie)
- SortOrder: `SortCriteria`und `SortDirection` enums
