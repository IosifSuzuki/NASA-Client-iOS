//
//  HomeCoordinator.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import SwiftUI

struct HomeCoordinator: View {
  @ObservedObject private var viewModel: HomeViewModel
  
  @State var isImageViewerPresented = false
  @State var isRoverPickerPresented = false
  @State var isCameraPickerPresented = false
  @State var isSaveFilterAlertPresented = false
  
  init() {
    let apiClient = APIClient()
    let filterDataManager = FilterDataManager(persistContainer: .shared)
    viewModel = HomeViewModel(apiClient: apiClient, filterDataManager: filterDataManager)
  }
  var body: some View {
    NavigationStack {
      HomeView(
        viewModel: viewModel,
        isImagePickerPresented: $isImageViewerPresented,
        isRoverPickerPresented: $isRoverPickerPresented,
        isCameraPickerPresented: $isCameraPickerPresented,
        isSaveFilterAlertPresented: $isSaveFilterAlertPresented
      )
      .fullScreenCover(isPresented: $isImageViewerPresented, content: {
        ImageViewerCoordinator(sourceURL: viewModel.selectedSourceImageURL)
      })
      .sheet(isPresented: $isCameraPickerPresented, content: {
        ItemPickerView(
          title: String(localized: "Camera"),
          selectedItem: $viewModel.selectedCameraItemPair,
          items: viewModel.cameraItems,
          presented: $isCameraPickerPresented
        )
        .presentationDetents([.height(306)])
        .presentationDragIndicator(.hidden)
      })
      .sheet(isPresented: $isRoverPickerPresented, content: {
        ItemPickerView(
          title: String(localized: "Rover"),
          selectedItem: $viewModel.selectedRoverItemPair,
          items: viewModel.roverItems,
          presented: $isRoverPickerPresented
        )
        .presentationDetents([.height(306)])
        .presentationDragIndicator(.hidden)
      })
      .alert(LocalizedStringKey("Home.SaveFilters.title"), isPresented: $isSaveFilterAlertPresented, actions: {
        Button(LocalizedStringKey("Save"), role: .cancel) {
          viewModel.saveFilter()
        }
        Button(LocalizedStringKey("Cancel"), role: .none) {
          isSaveFilterAlertPresented = false
        }
      }, message: {
        Text(LocalizedStringKey("Home.SaveFilters.subtitle"))
      })
    }
    .preferredColorScheme(.light)
  }
}

#Preview {
  HomeCoordinator()
}
