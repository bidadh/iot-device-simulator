/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 20:55
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Combine
import SwiftUI
import MapboxDirections

class Settings: ObservableObject {
  @Published var currentAsset: Asset? = nil
  @Published(initialValue: Profile.DRIVING) var currentProfile: Profile
}