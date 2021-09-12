/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 24/8/20 14:29
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import CoreLocation
import Combine
import MapboxDirections
import Alamofire

class PredefinedDirectionsService: DirectionsProvider {
  let requiresCoordinates: Bool = false

  func directions(coordinates: [CLLocationCoordinate2D], withProfile profile: DirectionsProfileIdentifier) -> AnyPublisher<Route, ServiceError> {
    let route: Route = load(self.route)
    return Just(route)
        .handleEvents(receiveOutput: { log.debug("route count: ", context: $0.coordinates.count) })
        .mapError { e in
          ServiceError.parsing(description: e.localizedDescription)
        }
        .eraseToAnyPublisher()
  }

  let route: String

  init(route: String) {
    self.route = route
  }
}

func load<T: Decodable>(_ filename: String) -> T {
  let data: Data

  guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
      else {
    fatalError("Couldn't find \(filename) in main bundle.")
  }

  do {
    data = try Data(contentsOf: file)
  } catch {
    fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
  }

  do {
    let decoder = JSONDecoder()
    let result: T = try decoder.decode(T.self, from: data)
    return result
  } catch {
    fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
  }
}
