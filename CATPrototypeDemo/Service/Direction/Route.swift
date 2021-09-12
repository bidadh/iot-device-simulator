/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 24/8/20 14:31
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import CoreLocation

struct Route: Codable {
  var id: String
  var finishAt: [[Double]]
  var startAt: [[Double]]
  var coordinates: [[Double]]
  let forceFit: Bool
  let forceFollow: Bool

  func route() -> [CLLocationCoordinate2D] {
    coordinates
        .enumerated()
        .filter {
          let (_,r) = $0.offset.quotientAndRemainder(dividingBy: env.speed.pickEvery)
          return r == 0
        }
        .map { $0.element }
        .map { doubles in
          CLLocationCoordinate2D(latitude: doubles[1], longitude: doubles[0])
        }
  }
}
