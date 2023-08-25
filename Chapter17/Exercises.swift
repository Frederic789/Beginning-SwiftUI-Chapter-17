
// Modified Exercise.swift
//  Exercises.swift
//  Chapter17
//
//  Created by Mike Panitz on 5/14/23.
//

import Foundation
import SwiftUI

// Define the ItemRow view
struct ItemRow: View {
    var item: Item

    var body: some View {
        Text(item.name)
    }
}

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let category: String
}

class ItemStore: ObservableObject {
    @Published var selectedItems: [Item] = []

    func addItem(_ item: Item) {
        selectedItems.append(item)
    }

    func removeItem(_ item: Item) {
        selectedItems.removeAll { $0.id == item.id }
    }
}



struct RPGShopView: View {
    @StateObject var itemStore = ItemStore()
    
    var body: some View {
        TabView {
            SummaryView(itemStore: itemStore)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Summary")
                }

            WeaponsView(itemStore: itemStore)
                .tabItem {
                    Image(systemName: "cross.circle.fill")
                    Text("Weapons")
                }

            ArmorView(itemStore: itemStore)
                .tabItem {
                    Image(systemName: "shield.fill")
                    Text("Armor")
                }
        }
    }
}

struct SummaryView: View {
    @ObservedObject var itemStore: ItemStore
    
    var body: some View {
        NavigationView {
            List(itemStore.selectedItems){item in
                Text(item.name)
            }
            .navigationTitle("Summary")
        }
    }
}

struct WeaponsView: View {
    @ObservedObject var itemStore: ItemStore
    
    var body: some View {
        List {
            ForEach(weaponsData) { weapon in
                ItemRow(item: weapon)
                    .swipeActions {
                        Button(role: .destructive) {
                            // Add the selected weapon to the item store
                            itemStore.addItem(weapon)
                        } label: {
                            Label("Purchase", systemImage: "cart.fill")
                        }
                    }
            }
        }
    }
}

struct ArmorView: View {
    @ObservedObject var itemStore: ItemStore
    
    var body: some View {
           List {
               ForEach(armorData) { armor in
                   ItemRow(item: armor)
                       .swipeActions {
                           Button(role: .destructive) {
                               // Add the selected armor to the item store
                               itemStore.addItem(armor)
                           } label: {
                               Label("Purchase", systemImage: "cart.fill")
                           }
                       }
               }
           }
       }
}

let weaponsData: [Item] = [
    Item(name: "Sword", category: "Weapon"),
    Item(name: "Bow", category: "Weapon"),
    Item(name: "Axe", category: "Weapon")
]

let armorData: [Item] = [
    Item(name: "Plate Mail", category: "Armor"),
    Item(name: "Leather Armor", category: "Armor"),
    Item(name: "Chainmail", category: "Armor")
]

struct RPGShopView_Previews: PreviewProvider {
    static var previews: some View {
        RPGShopView()
    }
}



