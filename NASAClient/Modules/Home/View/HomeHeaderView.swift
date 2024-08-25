//
//  HomeHeaderView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 24.08.2024.
//

import SwiftUI

struct HomeHeaderView: View {
  let title: String
  let date: String
  let selectedCameraText: String
  let selectedRoverText: String
  @Binding var isDatePickerPresented: Bool
  @Binding var isRoverPickerPresented: Bool
  @Binding var isCameraPickerPresented: Bool
  @Binding var isSaveFilterAlertPresented: Bool
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(Color.accentOne)
        .ignoresSafeArea(.all, edges: .top)
      VStack(spacing: 22) {
        HStack(alignment: .center) {
          VStack(alignment: .leading, spacing: 2) {
            Text(title)
              .appFont(with: .large)
              .foregroundStyle(Color.layerOne)
            Text(date)
              .appFont(with: .bodySecondary)
              .foregroundStyle(Color.layerOne)
          }
          Spacer()
          Button {
            withAnimation {
              isDatePickerPresented = true
            }
          } label: {
            Image(.calendar)
          }
          .frame(width: 44, height: 44)
        }
        filterView
      }
      .padding(EdgeInsets(top: 2, leading: 19, bottom: 20, trailing: 19))
    }
    .frame(height: 160)
  }
  
  var filterView: some View {
    HStack {
      FilterItemView(
        title: selectedRoverText,
        icon: Image(.rover),
        action: {
          isRoverPickerPresented = true
        })
      FilterItemView(
        title: selectedCameraText,
        icon: Image(.camera),
        action: {
          isCameraPickerPresented = true
        })
      Spacer()
      Button(action: {
        isSaveFilterAlertPresented = true
      }, label: {
        Image(systemName: "plus")
          .appFont(with: .bodySecondary)
          .foregroundStyle(.layerOne)
          .frame(width: 24, height: 24)
          .padding(.all, 7)
      })
      .background {
        RoundedRectangle(cornerRadius: 10)
          .fill(.backgroundOne)
          .appBackgroundShadow(with: 10)
      }
    }
  }
}

#Preview {
  HomeHeaderView(
    title: "MARS CAMERA",
    date: Date.now.toString(),
    selectedCameraText: "All",
    selectedRoverText: "All",
    isDatePickerPresented: .constant(false),
    isRoverPickerPresented: .constant(false),
    isCameraPickerPresented: .constant(false), 
    isSaveFilterAlertPresented: .constant(false)
  )
}
