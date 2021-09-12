/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 11/8/20 00:53
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import SwiftUI

struct CheckmarkModifier: ViewModifier {
  var checked: Bool = false
  func body(content: Content) -> some View {
    Group {
      if checked {
        ZStack(alignment: .trailing) {
          content
          Image(systemName: "checkmark")
              .resizable()
              .frame(width: 20, height: 20)
              .foregroundColor(.green)
              .shadow(radius: 1)
        }
      } else {
        content
      }
    }
  }
}
