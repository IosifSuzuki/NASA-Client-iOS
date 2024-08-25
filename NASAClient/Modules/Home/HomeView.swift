//
//  HomeView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import SwiftUI

struct HomeView: View {
  @ObservedObject var viewModel: HomeViewModel
  @State private var isDatePickerPresented = false
  @Binding var isImagePickerPresented: Bool
  @Binding var isRoverPickerPresented: Bool
  @Binding var isCameraPickerPresented: Bool
  @Binding var isSaveFilterAlertPresented: Bool
  
  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      VStack(spacing: .zero) {
        HomeHeaderView(
          title: viewModel.title,
          date: viewModel.selectedDateText,
          selectedCameraText: viewModel.selectedCameraText,
          selectedRoverText: viewModel.selectedRoverText,
          isDatePickerPresented: $isDatePickerPresented,
          isRoverPickerPresented: $isRoverPickerPresented,
          isCameraPickerPresented: $isCameraPickerPresented,
          isSaveFilterAlertPresented: $isSaveFilterAlertPresented
        )
        switch viewModel.state {
        case .noDate:
          noDate(
            title: String(localized: "Home.Photos.noData"),
            image: Image(systemName: "tray")
          )
        case .loading where viewModel.dataSource.isEmpty:
          LoadingView()
        case .failed(message: let message):
          noDate(
            title: message,
            image: Image(systemName: "bolt.trianglebadge.exclamationmark")
          )
        case .loading, .loadMore, .finished:
          ScrollView {
            LazyVStack {
              ForEach(viewModel.dataSource, id: \.id) { model in
                CardRoverView(model: model).onTapGesture {
                  didTap(cardRover: model)
                }
              }
              if viewModel.state == .loadMore || viewModel.state == .loading {
                LoadingRow(style: .long)
                  .frame(height: 50)
                  .onAppear {
                    viewModel.loadMoreData()
                  }
              }
            }
            .padding(.all, 20)
          }
        }
      }
      historyButton
      if isDatePickerPresented {
        DatePickerView(
          selectedDate: $viewModel.selectedDate,
          presented: $isDatePickerPresented
        )
      }
    }
    .onAppear {
      viewModel.reloadData()
    }
  }
  
  private func noDate(title: String, image: Image) -> some View {
    VStack {
      Spacer()
      NoDataView(
        title: title,
        image: image
      )
      .padding(.horizontal, 20)
      .fontWeight(.ultraLight)
      .foregroundStyle(.accent)
      Spacer()
    }
  }
  
  private var historyButton: some View {
    NavigationLink {
      HistoryCoordinator()
    } label: {
      ZStack {
        Color(.accentOne).clipShape(Circle())
        Image(.history)
      }
      .frame(width: 70, height: 70)
      .padding([.bottom, .trailing], 20)
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  func didTap(cardRover: CardRover) {
    viewModel.select(cardRover: cardRover)
    isImagePickerPresented = true
  }
}

#Preview {
  let apiClient = APIClient()
  let viewModel = HomeViewModel(apiClient: apiClient)
  return HomeView(
    viewModel: viewModel,
    isImagePickerPresented: .constant(false),
    isRoverPickerPresented: .constant(false),
    isCameraPickerPresented: .constant(false),
    isSaveFilterAlertPresented: .constant(false)
  )
}
