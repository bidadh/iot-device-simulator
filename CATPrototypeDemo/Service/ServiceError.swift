/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 12:50
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import Foundation

enum ServiceError: Error {
  case parsing(description: String)
  case network(description: String)
  case general
}
