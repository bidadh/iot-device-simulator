/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 02:10
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Foundation
import MapboxDirections
import Alamofire
import CoreLocation
import Combine

class DirectionsService: DirectionsProvider {
  let requiresCoordinates: Bool = true

  func directions(coordinates: [CLLocationCoordinate2D], withProfile profile: DirectionsProfileIdentifier) -> AnyPublisher<Route, ServiceError> {
    self.directions(from: coordinates.first!, to: coordinates.last!, withProfile: profile)
        .map { (localCoordinates: [CLLocationCoordinate2D]) -> Route in
          let doubles = localCoordinates.map { [$0.longitude, $0.latitude] }
          return Route(id: "mb-directions-route", finishAt: [], startAt: [], coordinates: doubles, forceFit: false, forceFollow: false)
        }
        .eraseToAnyPublisher()
  }

  let apiService: APIProvider = APIService()
  let directions = Directions.shared

  var token: String {
    Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken") as! String
  }

  func directions(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, withProfile profile: DirectionsProfileIdentifier = .automobile) -> AnyPublisher<[CLLocationCoordinate2D], ServiceError> {
    let waypoints = [
      Waypoint(coordinate: from),
      Waypoint(coordinate: to),
    ]
    let options = RouteOptions(waypoints: waypoints, profileIdentifier: profile)
//    options.includesSteps = true
    options.routeShapeResolution = .full
    options.shapeFormat = .geoJSON

    return Future<[CLLocationCoordinate2D], ServiceError> { promise in
      let task = self.directions.calculate(options) { (session, result) in

        promise(
            result
                .mapError { error in
                  .network(description: error.localizedDescription)
                }
                .map { response in
                  guard let coords: [CLLocationCoordinate2D] = response.routes?.first?.shape?.coordinates else {
                    return []
                  }

                  return coords
                }
        )
      }
      task.resume()
    }
        .eraseToAnyPublisher()
  }
}
