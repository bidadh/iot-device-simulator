/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 18:45
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Foundation
import CoreLocation

struct RouteRequest: Encodable {
  static func create(
      _ route: Route
  ) -> RouteRequest {
    RouteRequest(
        coordinates: route.coordinates,
        forceFit: route.forceFit,
        forceFollow: route.forceFollow
    )
  }

  let coordinates: Array<Array<Double>>
  let forceFit: Bool
  let forceFollow: Bool
}
