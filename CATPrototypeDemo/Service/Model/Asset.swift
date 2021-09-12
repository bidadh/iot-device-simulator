/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 20:48
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Foundation

struct Asset: Identifiable, Hashable, Decodable {
  let id: String
  let name: String
  let deviceId: String
}
