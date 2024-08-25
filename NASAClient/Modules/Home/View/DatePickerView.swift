//
//  DatePickerView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 24.08.2024.
//

import SwiftUI

struct DatePickerView: View {
  @Binding var selectedDate: Date
  @Binding var presented: Bool
	@State private var selectionDate: Date
  
  init(selectedDate: Binding<Date>, presented: Binding<Bool>) {
    _selectedDate = selectedDate
    _presented = presented
    selectionDate = selectedDate.wrappedValue
  }
  
  var body: some View {
    ZStack {
      Color.layerOne
        .opacity(0.4)
        .ignoresSafeArea()
      VStack {
        HStack {
          closeButton
          Spacer()
          Text(LocalizedStringKey("Date"))
            .appFont(with: .titleSecondary)
            .foregroundStyle(.layerOne)
          Spacer()
          trickButton
        }
        DatePicker(LocalizedStringKey("Date"), selection: $selectionDate, displayedComponents: [.date])
          .datePickerStyle(.wheel)
          .labelsHidden()
      }
      .padding(.all, 20)
      .appBackgroundShadow(with: 30)
      .scenePadding()
    }
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
      selectedDate = selectionDate
      presented = false
    }, label: {
      Image(.tick)
    })
  }
  
}

#Preview {
  DatePickerView(selectedDate: .constant(.now), presented: .constant(true))
}
