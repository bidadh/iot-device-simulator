/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 8/8/20 11:14
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Combine
import MapKit

class MainViewModel: ObservableObject {
  @Published(initialValue: [MKPointAnnotation]()) var locations: [MKPointAnnotation]
  @Published(initialValue: CLLocationCoordinate2D()) var centerCoordinate: CLLocationCoordinate2D
  @Published(initialValue: nil) var lastPosition: CLLocationCoordinate2D?
  @Published(initialValue: nil) var asset: Asset?
  @Published(initialValue: nil) var route: Route?
  @Published(initialValue: [CLLocationCoordinate2D]()) var routeCoordinates: [CLLocationCoordinate2D]
  @Published(initialValue: CLLocationCoordinate2D()) var currentCoordinate: CLLocationCoordinate2D
  @Published(initialValue: false) var legIsFinished: Bool

/*
  init() {
    $legIsFinished.dropFirst()
        .filter { $0 && self.lastPosition != nil && self.asset != nil}
        .flatMap { (_: Bool) -> AnyPublisher<String, ServiceError> in
          self.catService.finishLegFor(self.asset!, at: self.lastPosition!)
        }
        .sink(
            receiveValue: { data in
              log.warning("FinishLeg", context: data)
            }
        )
        .store(in: &disposables)
  }
*/

  var isReady: Bool {
    !self.directionsService.requiresCoordinates || self.locations.count == 2
  }

  var hasLocation: Bool {
    self.locations.count > 0
  }

  var needsLocation: Bool {
    self.locations.count < 2
  }

  private var disposables = Set<AnyCancellable>()

  let directionsService = env.directionsService
  let catService = CATService()

  func clearLocations() {
    locations.removeAll()
  }

  func cleanup() {
    guard let route = self.route else {
      return
    }

    if route.forceFit && route.forceFollow && !route.finishAt.isEmpty {
      self.catService.zoomAt(self.asset!, at: self.route!.finishAt)
          .sink(
              receiveCompletion: { value in
                switch value {
                case .failure(let f):
                  log.error("fetch Error", context: f)
                case .finished:
                  log.warning("Finished Leg!")
                  break
                }
              },
              receiveValue: { data in
                log.info("Finished Leg!", context: data)
              })
          .store(in: &disposables)

    }

    self.route = nil
    clearLocations()
    routeCoordinates = []
    legIsFinished = true
  }

  func append() {
    let newLocation = MKPointAnnotation()
    newLocation.coordinate = self.centerCoordinate
    self.locations.append(newLocation)
  }

  func updateCurrentCoordinate(currentCoordinate: CLLocationCoordinate2D) {
    self.currentCoordinate = currentCoordinate
  }

  func sendEvent(asset: Asset?, criticality: String, key: String, message: String) {
    guard let asset = asset else {
      return
    }

    log.warning("SENDING \(criticality) EVENT key: '\(key)'")

    self.asset = asset

    catService.sendEventFor(asset, position: self.currentCoordinate, with: criticality, key, message)
        .sink(
            receiveCompletion: { value in
              switch value {
              case .failure(let f):
                log.error("fetch Error", context: f)
              case .finished:
                log.warning("COMPLETED!!!!!")
                break
              }
            },
            receiveValue: { data in
              log.info("fetch Success", context: data)
              log.info("DONE!")
            })
        .store(in: &disposables)
  }

  func start(asset: Asset?, withProfile profile: Profile) {
    guard let asset = asset else {
      return
    }

    self.asset = asset

    directionsService.directions(coordinates: locations.map {
          $0.coordinate
        }, withProfile: profile.value)
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveOutput: {
          self.route = $0
          self.routeCoordinates = $0.route()
        })
        .flatMap {
          self.catService.sendRouteFor(asset, route: $0)
        }
        .flatMap {
          self.catService.startMoving(asset, fromCoordinate: $0, callback: self.updateCurrentCoordinate)
        }
        .handleEvents(receiveOutput: {
          self.lastPosition = $0
        })
        .sink(
            receiveCompletion: { value in
              switch value {
              case .failure(let f):
                log.error("fetch Error", context: f)
              case .finished:
                self.cleanup()
                log.warning("COMPLETED!!!!!")
                break
              }
            },
            receiveValue: { data in
              log.info("fetch Success", context: data)
              log.info("DONE!")
            })
        .store(in: &disposables)
  }
}
