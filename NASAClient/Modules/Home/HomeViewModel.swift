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
  @Published var selectedRoverText = ""
  @Published var selectedCameraText = ""
  @Published var selectedDateText = ""
  @Published var selectedDate: Date
  @Published var selectedRoverItemPair: ItemPair?
  @Published var selectedCameraItemPair: ItemPair?
  @Published var filter: Filter
  @Published var state: State = .noDate
  
  var roverItems: [ItemPair] {
    RoverOption.allCases.map { option in
      ItemPair(id: option.rawValue, title: option.name)
    }
  }
  
  var cameraItems: [ItemPair] {
    filter.roverOption.availableCams.map { option in
      ItemPair(id: option.rawValue, title: option.fullName)
    }
  }
  
  var selectedSourceImageURL: URL? {
    selectedCardRover?.imageURL
  }
  
  private var selectedCardRover: CardRover?
  private let pageSize: Int = 25
  private var page: Int = 1
  private let apiClient: APIClient
  private let filterDataManager: FilterDataManager
  private var fetchSubcription: AnyCancellable?
  private var bag = Set<AnyCancellable>()
  
  init(apiClient: APIClient, filterDataManager: FilterDataManager) {
    self.title = String(localized: "Home.title")
    self.apiClient = apiClient
    self.filterDataManager = filterDataManager
    let selectedDate = Date.date(year: 2023, month: 12, day: 01) ?? .now
    self.selectedDate = selectedDate
    filter = Filter(
      roverOption: .curiosity,
      cameraOption: .chemcam,
      date: selectedDate
    )
    selectedRoverItemPair = .init(id: filter.roverOption.rawValue, title: filter.roverOption.name)
    selectedCameraItemPair = .init(id: filter.cameraOption.rawValue, title: filter.cameraOption.shortName)
    addObservers()
  }
  
  func select(cardRover: CardRover) {
    selectedCardRover = cardRover
  }
  
  func saveFilter() {
    do {
      try filterDataManager.save(filter: filter)
    } catch {
      print(error)
    }
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
  
  func apply(filter: Filter) {
    selectedDate = filter.date
    selectedRoverItemPair = .init(id: filter.roverOption.rawValue, title: filter.roverOption.name)
    selectedCameraItemPair = .init(id: filter.cameraOption.rawValue, title: filter.cameraOption.shortName)
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
        roverOption: filter.roverOption,
        cameraOption: filter.cameraOption,
        date: filter.date,
        page: page
      ),
      body: nil
    )
    return apiClient.request(request: request)
  }
  
  private func addObservers() {
    Publishers.CombineLatest3($selectedRoverItemPair, $selectedCameraItemPair, $selectedDate)
      .compactMap { roverItemPair, cameraItemPair, date -> Filter? in
        let defaultRoverOption: RoverOption = .curiosity
      	var roverOption: RoverOption = defaultRoverOption
        if let optionID = roverItemPair?.id {
          roverOption = RoverOption(rawValue: optionID) ?? defaultRoverOption
        }
        
        let defaultCameraOption: CameraOption = .fhaz
        var cameraOption: CameraOption = defaultCameraOption
        if let optionID = cameraItemPair?.id {
          cameraOption = CameraOption(rawValue: optionID) ?? defaultCameraOption
        }
        if !roverOption.availableCams.contains(cameraOption) {
          cameraOption = roverOption.availableCams.first ?? defaultCameraOption
        }
        
        return Filter(
          roverOption: roverOption,
          cameraOption: cameraOption,
          date: date
        )
      }
      .sink(receiveValue: { [weak self] filter in
        self?.filter = filter
        self?.reloadData()
      })
      .store(in: &bag)
    
    $filter
      .sink { [weak self] filter in
        self?.selectedRoverText = filter.roverOption.name
        self?.selectedCameraText = filter.cameraOption.shortName
        self?.selectedDateText = filter.date.toString(format: "MMMM d, yyyy").capitalized
      }
      .store(in: &bag)
  }
}
