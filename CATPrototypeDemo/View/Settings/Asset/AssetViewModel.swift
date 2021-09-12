/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 20:37
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Combine
import SwiftUI

class AssetViewModel: ObservableObject {
  @Published(initialValue: []) var assets: [Asset]

  let catService = CATService()
  let scheduler = DispatchQueue(label: "AssetsViewModel")

  func fetchAssets() {
    log.info("Fetching homepage movies....")
    fetch(catService.assets(), failureHandler: { [weak self] in self?.assets = [] }) { [weak self] (data: [Asset]) in
      guard let self = self else {
        return
      }

      self.assets = data
    }
  }

  func fetch<T: Decodable>(
      _ publisher: AnyPublisher<[T], ServiceError>,
      failureHandler: @escaping () -> Void,
      successHandler: @escaping ([T]) -> Void
  ) {
    publisher
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { value in
              switch value {
              case .failure(let f):
                log.error("fetch Error", context: f)
                failureHandler()
              case .finished:
                break
              }
            },
            receiveValue: { data in
              log.info("fetch Success", context: data.count)
              successHandler(data)
            })
        .store(in: &disposables)
  }


  private var disposables = Set<AnyCancellable>()
}
