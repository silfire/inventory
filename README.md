# Projektwoche #1 / Inventory
## `SwiftData` & `SwiftUI`- Übungen
Eine einfache Gegenstandsverwaltung für den Haushalt 

#### Aktuelle Aufgabenverteilung:
- Domenik: SettingsView
- Kevin: ItemDetailView
- Daniel: SearchListView
- Nicolas: UML, Struktur, KLassifizierungen
- Ingo: Basis-Projektcode und -pflege, sowie Feinschliff

#### Struktur der App:
Mit der App kann kann Gegenstände im Haushalt verwalten. Die Gegenstände kann man frei kategorisieren.

#### Struktur des Codes:
- `ContenView` mit TabBar
  - `ItemListView` (Gegenstände)
    - `ItemDetailView` per NavigationLink
    - `AddItemView` per Toolbar-Button
    - `SettingsView` per Toolbar-Button
  - `ÌtemTypeListView` (Kategorien)
  - `SearchListView` (Gegenstandssuche)

#### SwiftData:
- `Item` (Gegenstand)
- `ItemType` (Kategorie)
- `DataProvider`: Singleton, stellt den ModelContainer als .shared oder .preview (inMemory) bereit
