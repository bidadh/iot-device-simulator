/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 18:44
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Foundation
import CoreLocation

struct PositionUpdateRequest: Encodable {
  let position: PositionUpdate
  let properties: Dictionary<String, String>
}

struct PositionUpdate: Encodable {
  let type: String
  let coordinates: Array<Double>

  static func point(coordinates: CLLocationCoordinate2D) -> PositionUpdate {
    PositionUpdate(type: "Point", coordinates: [coordinates.longitude, coordinates.latitude])
  }
}
