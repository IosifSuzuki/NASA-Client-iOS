//
//  HistoryCoordinator.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import SwiftUI

struct HistoryCoordinator: View {
  @ObservedObject var viewModel: HistoryViewModel
  @Environment(\.presentationMode) var presentationMode
  
  @State var isConfirmationDialogPresented = false
  var applyFilter: (Filter) -> ()
  init(applyFilter: @escaping ((Filter) -> ())) {
    let filterDataManager = FilterDataManager(persistContainer: .shared)
    self.viewModel = HistoryViewModel(filterDataManager: filterDataManager)
    self.applyFilter = applyFilter
  }
  
  var body: some View {
    VStack {
      Rectangle()
        .fill(Color.accentOne)
        .ignoresSafeArea()
        .frame(height: 20)
      HistoryView(
        viewModel: viewModel,
        isConfirmationDialogPresented: $isConfirmationDialogPresented
      )
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbarBackground(.clear, for: .navigationBar)
      .toolbarBackground(.hidden, for: .navigationBar)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text(viewModel.title)
            .appFont(with: .large)
            .foregroundStyle(.layerOne)
        }
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image(.back)
          }
        }
      }
      .confirmationDialog(
        LocalizedStringKey("History.menuFilter"),
        isPresented: $isConfirmationDialogPresented,
        titleVisibility: .visible
      ) {
        Button(LocalizedStringKey("Use")) {
          isConfirmationDialogPresented = false
          if let selectedFilter = viewModel.selectedFilter {
            presentationMode.wrappedValue.dismiss()
            applyFilter(selectedFilter)
          }
        }
        Button(LocalizedStringKey("Delete"), role: .destructive) {
          viewModel.deleteFilter()
          isConfirmationDialogPresented = false
        }
        Button(LocalizedStringKey("Cancel"), role: .cancel) {
          isConfirmationDialogPresented = false
        }
      }
    }
  }
}

#Preview {
  HistoryCoordinator(applyFilter: { _ in })
}
