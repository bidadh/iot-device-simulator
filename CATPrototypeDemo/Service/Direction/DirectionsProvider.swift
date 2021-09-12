/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 24/8/20 14:30
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import CoreLocation
import MapboxDirections
import Combine

protocol DirectionsProvider {
  var requiresCoordinates: Bool { get }
  func directions(coordinates: [CLLocationCoordinate2D], withProfile profile: DirectionsProfileIdentifier) -> AnyPublisher<Route, ServiceError>
}
