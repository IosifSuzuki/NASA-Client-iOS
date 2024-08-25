//
//  ImageViewController.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import Foundation
import UIKit
import Combine

class ImageViewController: UIViewController {
  private lazy var scrollView = {
    let scrollView = UIScrollView()
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.delegate = self
    
    return scrollView
  }()
  
  private lazy var activityIndicator = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.isHidden = true
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.style = .large
    activityIndicator.color = UIColor(resource: .accentOne)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    activityIndicator.startAnimating()
    
    return activityIndicator
  }()
  
  private lazy var errorLabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 32, weight: .bold)
    label.textColor = .black
    label.isHidden = true
    
    return label
  }()
  
  private var currentImageLoader: ImageLoader?
  private lazy var imageView = UIImageView()
  private var bag: Set<AnyCancellable> = []
  private var sourceURL: URL?
  
  // MARK: - Initializer
  
  static func instantiate(with sourceURL: URL?) -> ImageViewController {
    let viewController = ImageViewController()
    viewController.sourceURL = sourceURL
    
    return viewController
  }
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureLayout()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
    tapGesture.numberOfTapsRequired = 2
    scrollView.addGestureRecognizer(tapGesture)
    
    let imageLoader = ImageLoader(url: sourceURL)
    imageLoader
      .$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        switch state {
        case .loading:
          self?.activityIndicator.isHidden = false
          self?.errorLabel.isHidden = true
        case let .finished(image: image):
          self?.activityIndicator.isHidden = true
          self?.errorLabel.isHidden = true
          self?.configureSizeAndZoomScale(image: image)
        case let .failed(message: message):
          self?.activityIndicator.isHidden = true
          self?.errorLabel.isHidden = false
          self?.errorLabel.text = message
        }
      }
      .store(in: &bag)
    
    // Prevent release the ImageLoader. Keep the ImageLoader in memory during the lifecycle of the view controller
    self.currentImageLoader = imageLoader
  }
  
  // MARK: - Actions
  
  @objc private func didDoubleTap(recognizer: UITapGestureRecognizer) {
    let pointInView = recognizer.location(in: imageView)
    if scrollView.zoomScale < scrollView.maximumZoomScale {
      zoomToScale(scale: scrollView.maximumZoomScale, pointInView: pointInView)
    } else {
      zoomToScale(scale: scrollView.minimumZoomScale, pointInView: pointInView)
    }
  }
  
  // MARK: - Common
  
  private func configureLayout() {
    scrollView.pinToContainer(view)
    
    view.addSubview(errorLabel)
    NSLayoutConstraint.activate([
      errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    
    view.addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    view.bringSubviewToFront(activityIndicator)
  }
  
  private func configureSizeAndZoomScale(image: UIImage?) {
    guard let image else {
      return
    }
    imageView.image = image
    imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)
    scrollView.addSubview(imageView)
    scrollView.contentSize = image.size
    
    let scrollViewFrame = scrollView.frame
    let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
    let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
    let minScale = min(scaleWidth, scaleHeight)
    
    scrollView.minimumZoomScale = minScale
    scrollView.maximumZoomScale = 1.0
    scrollView.zoomScale = minScale
    
    centerScrollViewContents()
  }
  
  private func centerScrollViewContents() {
    let boundsSize = scrollView.bounds.size
    var contentsFrame = imageView.frame
    
    if contentsFrame.size.width < boundsSize.width {
      contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
    } else {
      contentsFrame.origin.x = 0.0
    }
    
    if contentsFrame.size.height < boundsSize.height {
      contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
    } else {
      contentsFrame.origin.y = 0.0
    }
    
    imageView.frame = contentsFrame
  }
  
  private func zoomToScale(scale: CGFloat, pointInView: CGPoint) {
    let scrollViewSize = scrollView.bounds.size
    let w = scrollViewSize.width / scale
    let h = scrollViewSize.height / scale
    let x = pointInView.x - (w / 2.0)
    let y = pointInView.y - (h / 2.0)
    
    let rectToZoomTo = CGRectMake(x, y, w, h);
    
    scrollView.zoom(to: rectToZoomTo, animated: true)
  }
  
}

//MARK: - UIScrollViewDelegate
extension ImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    centerScrollViewContents()
  }
}

fileprivate extension UIView {
  func pinToContainer(_ container: UIView) {
    container.addSubview(self)
    let constraints = [
      container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .zero),
      container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .zero),
      container.topAnchor.constraint(equalTo: topAnchor, constant: .zero),
      container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: .zero)
    ]
    constraints.forEach { $0.isActive = true }
  }
}
