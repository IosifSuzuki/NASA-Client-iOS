//
//  CardRoverView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import SwiftUI

struct CardRoverView: View {
  let model: CardRover
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 6) {
        AttributedLabel(key: "Rover: ", value: model.name)
        AttributedLabel(key: "Camera: ", value: model.camera)
        AttributedLabel(key: "Date: ", value: model.date)
      }
      Spacer()
      RemoteImage(url: model.imageURL)
        .frame(width: 130, height: 130)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .aspectRatio(contentMode: .fill)
    }
    .padding(.all, 10)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .appBackgroundShadow(with: 20)
  }
}

#Preview {
  let url = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/rcam/RLB_486265291EDR_F0481570RHAZ00323M_.JPG")!
  let model = CardRover(
    id: 1,
    name: "Curiosity",
    camera: "Front Hazard Avoidance Camera",
    date: "June 6, 2019",
    imageURL: url
  )
  return CardRoverView(model: model)
}
