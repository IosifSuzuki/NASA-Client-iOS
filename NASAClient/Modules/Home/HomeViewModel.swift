//
//  HomeViewModel.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
  enum State: Equatable {
    case loading
    case loadMore
    case finished
    case failed(message: String)
    case noDate
  }
  
  @Published var title: String
  @Published var dataSource: [CardRover] = []
  @Published var selectedDate: Date
  @Published var selectedRoverText: String
  @Published var selectedCameraText: String
  @Published var selectedRoverItemPair: ItemPair?
  @Published var selectedCameraItemPair: ItemPair?
  @Published var state: State = .noDate
  
  var selectedDateText: String {
    selectedDate
      .toString(format: "MMMM d, yyyy")
      .capitalized
  }
  
  var roverItems: [ItemPair] {
    RoverOption.allCases.enumerated().map { idx, option in
      ItemPair(index: idx, title: option.name)
    }
  }
  
  var cameraItems: [ItemPair] {
    selectedRoverOption.availableCams.enumerated().map { idx, option in
      ItemPair(index: idx, title: option.fullName)
    }
  }
  
  var selectedSourceImageURL: URL? {
    selectedCardRover?.imageURL
  }
  
  private var selectedRoverOption: RoverOption = .curiosity
  private var selectedCameraOption: CameraOption = .navcam
  private var selectedCardRover: CardRover?
  private let pageSize: Int = 25
  private var page: Int = 1
  private let apiClient: APIClient
  private var fetchSubcription: AnyCancellable?
  private var bag = Set<AnyCancellable>()
  
  init(apiClient: APIClient) {
    self.title = String(localized: "Home.title")
    self.apiClient = apiClient
    self.selectedDate = Date.date(year: 2023, month: 12, day: 01) ?? .now
    self.selectedRoverText = selectedRoverOption.name
    self.selectedCameraText = selectedCameraOption.shortName
    
    addObservers()
  }
  
  func select(cardRover: CardRover) {
    selectedCardRover = cardRover
  }
  
  func saveFilter() {
    
  }
  
  func loadMoreData() {
    guard case .loadMore = state else {
      return
    }
    page += 1
    fetchPhotos()
  }
  
  func reloadData() {
    page = 1
    dataSource = []
    fetchSubcription?.cancel()
    fetchPhotos()
  }
  
  private func fetchPhotos() {
    state = .loading
    fetchSubcription = preparePhotosRequest()
      .receive(on: RunLoop.main)
      .map { photos in
        photos.photos.map { photo in
          CardRover(
            id: photo.id,
            name: photo.rover.name,
            camera: photo.camera.fullName,
            date: photo.earthDate.toString(),
            imageURL: photo.url
          )
        }
      }
      .sink { [weak self] result in
        switch result {
        case .finished:
          break
        case .failure(let error):
          self?.state = .failed(message: error.localizedDescription)
        }
      } receiveValue: { [weak self] cardRovers in
        guard let self else {
          return
        }
        self.dataSource.append(contentsOf: cardRovers)
        self.state = if self.dataSource.isEmpty{
          .noDate
        } else if cardRovers.count < pageSize {
          .finished
        } else {
          .loadMore
        }
      }
  }
  
  private func preparePhotosRequest() -> AnyPublisher<Photos, HTTP.NetworkError> {
    let request = HTTP.Request(
      endpoint: NASAEndpoints.photos(
        roverOption: selectedRoverOption,
        cameraOption: selectedCameraOption,
        date: selectedDate,
        page: page
      ),
      body: nil
    )
    return apiClient.request(request: request)
  }
  
  private func addObservers() {
    $selectedRoverItemPair
      .map { [weak self] itemPair -> RoverOption in
        guard let self else {
          return .curiosity
        }
        if let id = itemPair?.index, RoverOption.allCases.indices.contains(id) {
          return RoverOption.allCases[id]
        } else if RoverOption.allCases.contains(self.selectedRoverOption){
          return self.selectedRoverOption
        }
        return .curiosity
      }
      .sink(receiveValue: { [weak self] roverOption in
        guard let self else {
          return
        }
        
        self.selectedRoverOption = roverOption
        self.selectedRoverText = roverOption.name
        
        if !roverOption.availableCams.contains(self.selectedCameraOption) {
          self.selectedCameraOption = roverOption.availableCams.first ?? .fhaz
          self.selectedCameraText = self.selectedCameraOption.shortName
        }
        
        self.reloadData()
      })
      .store(in: &bag)
    $selectedCameraItemPair
      .map { [weak self] itemPair -> CameraOption in
        guard let self else {
          return .fhaz
        }
        if let id = itemPair?.index, self.selectedRoverOption.availableCams.indices.contains(id) {
          return self.selectedRoverOption.availableCams[id]
        } else if self.selectedRoverOption.availableCams.contains(self.selectedCameraOption) {
          return self.selectedCameraOption
        }
        return self.selectedRoverOption.availableCams.first ?? .fhaz
      }
      .sink(receiveValue: { [weak self] cameraOption in
        self?.selectedCameraOption = cameraOption
        self?.selectedCameraText = cameraOption.shortName
        self?.reloadData()
      })
      .store(in: &bag)
    $selectedDate
      .sink(receiveValue: { [weak self] selectedDate in
        self?.reloadData()
      })
      .store(in: &bag)
  }
}
