//
//  HistoryView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import SwiftUI

struct HistoryView: View {
  @ObservedObject var viewModel: HistoryViewModel
  @Binding var isConfirmationDialogPresented: Bool
  
  var body: some View {
    ZStack {
        if viewModel.dataSource.isEmpty {
          NoDataView(
            title: String(localized: "History.noDate"),
            image: Image(.emptyHistory)
          )
        }
        ScrollView {
          LazyVStack(spacing: 12) {
            ForEach(viewModel.dataSource, id: \.id) { model in
              CardHistoryView(model: model)
                .onTapGesture {
                  viewModel.select(cardHistoryModel: model)
                  isConfirmationDialogPresented = true
                }
            }
          }
          .padding(.all, 20)
        }
    }.onAppear {
      viewModel.loadData()
    }
  }
}

#Preview {
  let filterDataManager = FilterDataManager(persistContainer: .shared)
  let viewModel = HistoryViewModel(
    filterDataManager: filterDataManager
  )
  return HistoryView(
    viewModel: viewModel,
    isConfirmationDialogPresented: .constant(false)
  )
}
