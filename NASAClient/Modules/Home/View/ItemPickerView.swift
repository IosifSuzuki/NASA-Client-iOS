//
//  ItemPickerView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 24.08.2024.
//

import SwiftUI

struct ItemPickerView: View {
  let title: String
  private var items: [ItemPair]
  @State private var selectionItem: ItemPair?
  @Binding var selectedItem: ItemPair?
  @Binding var presented: Bool
  
  init(title: String, selectedItem: Binding<ItemPair?>, items: [ItemPair], presented: Binding<Bool>) {
    self.title = title
    self.items = items
    selectionItem = selectedItem.wrappedValue
    _selectedItem = selectedItem
    _presented = presented
  }
  
  var body: some View {
      VStack {
        HStack {
          closeButton
          Spacer()
          Text(title)
            .appFont(with: .titleSecondary)
            .foregroundStyle(.layerOne)
          Spacer()
          trickButton
        }
        Picker(title, selection: $selectionItem) {
          ForEach(items, id: \.self) { item in
            Text(item.title).tag(item as ItemPair?)
          }
        }
        .pickerStyle(.wheel)
      }
      .background { Color.backgroundOne }
      .padding(.horizontal, 20)
  }
  
  private var closeButton: some View {
    Button(action: {
      presented = false
    }, label: {
      Image(.darkClose)
    })
  }
  
  private var trickButton: some View {
    Button(action: {
      selectedItem = selectionItem
      presented = false
    }, label: {
      Image(.tick)
    })
  }
}

#Preview {
  let items = [
    ItemPair(id: 0, title: "Front Hazard Avoidance Camera"),
    ItemPair(id: 1, title: "Rear Hazard Avoidance Camera"),
    ItemPair(id: 2, title: "Mast Camera"),
    ItemPair(id: 3, title: "Chemistry and Camera Complex"),
    ItemPair(id: 4, title: "Mars Hand Lens Imager"),
    ItemPair(id: 5, title: "Mars Descent Imager"),
    ItemPair(id: 6, title: "Navigation Camera"),
    ItemPair(id: 7, title: "Panoramic Camera"),
  	ItemPair(id: 8, title: "Miniature Thermal Emission Spectrometer (Mini-TES)"),
  ]
  let selectedItem: ItemPair = items.first!
  return ItemPickerView(
    title: "Camera", 
    selectedItem: .constant(nil),
    items: items,
    presented: .constant(true)
  )
}
