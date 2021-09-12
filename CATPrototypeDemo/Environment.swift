/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 24/8/20 14:36
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import CoreLocation

let finnairResourceUrl = "http://localhost:8186"
let ospentosResourceUrl = "http://localhost:8185"

let catProviderBaseUrl = "http://localhost:8181"
let authorizedEntity = "Finnair"

protocol Environment {
  var resourceBaseUrl: String { get }
  var providerBaseUrl: String { get }
  var enterpriseId: String { get }
  var center: CLLocationCoordinate2D { get }
  var directionsService: DirectionsProvider { get }
  var speed: Speed { get }
  var entity: String { get }
}

struct Ericsson: Environment {
  let resourceBaseUrl: String = finnairResourceUrl
  let providerBaseUrl: String = catProviderBaseUrl
  let enterpriseId: String = "5f2d3ca5772cb50d35f1f7fb"
  let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 59.4046, longitude: 17.9543)
  let directionsService: DirectionsProvider = DirectionsService()
  let speed = Speed.slow
  let entity: String = authorizedEntity
}

struct Sandvik: Environment {
  let resourceBaseUrl: String = finnairResourceUrl
  let providerBaseUrl: String = catProviderBaseUrl
  let enterpriseId: String = "5f3cb715804d001c9eaa6845"
  let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 60.17685723584867, longitude: 18.18113380362479)
  let directionsService: DirectionsProvider = PredefinedDirectionsService(route: "route-02.json")
  let speed = Speed.normal
  let entity: String = authorizedEntity
}

struct LH3: Environment {
  let resourceBaseUrl: String = finnairResourceUrl
  let providerBaseUrl: String = catProviderBaseUrl
  let enterpriseId: String = "5f583e141480fc29c28aee92"
  let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 52.573922, longitude: -1.762870)
  let directionsService: DirectionsProvider = PredefinedDirectionsService(route: "lh3-route.json")
  let speed = Speed.fast
  let entity: String = authorizedEntity
}

struct Factory: Environment {
  let resourceBaseUrl: String = finnairResourceUrl
  let providerBaseUrl: String = catProviderBaseUrl
  let enterpriseId: String = "5f631dded38f3d1399cc60c8"
  let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 60.6499909350286, longitude: 17.015086157249698)
  let directionsService: DirectionsProvider = PredefinedDirectionsService(route: "factory-to-gavle.json")
  let speed = Speed.normal
  let entity: String = authorizedEntity
}

struct Finnair: Environment {
  let resourceBaseUrl: String = finnairResourceUrl
  let providerBaseUrl: String = catProviderBaseUrl
  let enterpriseId: String = "613b258e75039d1a5aef2a08"
  let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 60.46560407525638, longitude: 22.26400360560277)
  let directionsService: DirectionsProvider = PredefinedDirectionsService(route: "turku-to-helsinki-airport.json")
  let speed = Speed.slow
  let entity: String = authorizedEntity
}

struct Hamburg: Environment {
  let resourceBaseUrl: String = finnairResourceUrl
  let providerBaseUrl: String = catProviderBaseUrl
  let enterpriseId: String = "5f631dded38f3d1399cc60c8"
  let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 53.50369889141146, longitude: 9.92820416461862)
  let directionsService: DirectionsProvider = PredefinedDirectionsService(route: "gavle-to-hamburg.json")
  let speed = Speed.superFast
  let entity: String = authorizedEntity
}

let env: Environment = Finnair()

struct Speed {
  let pickEvery: Int
  let simulationDelay: Double

  static let superFast = Speed(pickEvery: 80, simulationDelay: 1.5)
  static let fast = Speed(pickEvery: 40, simulationDelay: 1.75)
  static let normal = Speed(pickEvery: 25, simulationDelay: 1.75)
  static let slow = Speed(pickEvery: 10, simulationDelay: 5)
  static let superSlow = Speed(pickEvery: 7, simulationDelay: 6)
}

