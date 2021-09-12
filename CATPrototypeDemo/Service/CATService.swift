/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 02:11
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Foundation
import Alamofire
import CoreLocation
import Combine

class CATService {
  private let apiService = APIService()
  private var disposables = Set<AnyCancellable>()

  func sendRouteFor(_ asset: Asset, route: Route) -> AnyPublisher<[CLLocationCoordinate2D], ServiceError> {
    let coordinates = route.route()
    log.info("\(coordinates)")
    _ = RouteRequest.create(route)
    let updateRoute = self.apiService.post(uri: "/demo/route/\(env.enterpriseId)/\(asset.deviceId)", parameters: route, validate: true, debug: true)

    var action: AnyPublisher<String, ServiceError>
    if route.startAt.isEmpty {
      action = updateRoute
    } else {
      action = self.zoomAt(asset, at: route.startAt)
          .flatMap { _ in
            updateRoute
          }
          .eraseToAnyPublisher()
    }
    return action
        .map { _ in
          coordinates
        }
        .eraseToAnyPublisher()
  }

  func startMoving(
      _ asset: Asset,
      fromCoordinate coordinates: [CLLocationCoordinate2D],
      callback: @escaping (CLLocationCoordinate2D) -> Void
  ) -> AnyPublisher<CLLocationCoordinate2D, ServiceError> {
    log.info("\(coordinates)")

    let delayPublisher = Timer.publish(every: env.speed.simulationDelay, on: .main, in: .default).autoconnect()
    let delayedValuesPublisher = Publishers.Zip(coordinates.publisher, delayPublisher)
        .mapError { _ in
          ServiceError.general
        }
        .eraseToAnyPublisher()
    return delayedValuesPublisher
        .map {
          $0.0
        }
        .flatMap { (position: CLLocationCoordinate2D) -> AnyPublisher<CLLocationCoordinate2D, ServiceError> in
          let properties = ["status": "Moving..."]
          let request = PositionUpdateRequest(position: PositionUpdate.point(coordinates: position), properties: properties)
          callback(position)
          return self.apiService.post(uri: "/position/\(env.enterpriseId)/\(asset.deviceId)", parameters: request, validate: true, debug: false)
              .map { _ in
                position
              }
              .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
//        .sink(
//            receiveCompletion: { value in
//              switch value {
//              case .failure(let f):
//                log.error("fetch Error", context: f)
//              case .finished:
//                break
//              }
//            },
//            receiveValue: { data in
//              log.info("fetch Success", context: data)
//              log.info("DONE!")
//            })
//        .store(in: &disposables)
//
//    return Just("OK")
//        .mapError { _ in
//          ServiceError.general
//        }
//        .eraseToAnyPublisher()
  }

  func sendEventFor(_ asset: Asset, position: CLLocationCoordinate2D, with criticality: String, _ key: String, _ message: String) -> AnyPublisher<String, ServiceError> {
    let properties = [
      key: message,
      "criticality": criticality
    ]
    let request = PositionUpdateRequest(position: PositionUpdate.point(coordinates: position), properties: properties)
    return self.apiService.post(uri: "/position/\(env.enterpriseId)/\(asset.deviceId)", parameters: request, validate: true, debug: false)
        .eraseToAnyPublisher()
  }

  func zoomAt(_ asset: Asset, at points: [[Double]]) -> AnyPublisher<String, ServiceError> {
    let request = [
      "points": points
    ]
    return self.apiService.post(uri: "/demo/zoomAt/\(env.enterpriseId)/\(asset.deviceId)", parameters: request, validate: true, debug: false)
        .eraseToAnyPublisher()
  }

  func assets() -> AnyPublisher<[Asset], ServiceError> {
    apiService.get(uri: "/asset/\(env.enterpriseId)")
        .eraseToAnyPublisher()
  }
}
