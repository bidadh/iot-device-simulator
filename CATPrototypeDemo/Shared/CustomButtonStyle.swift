/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 12:56
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
  var bgColor: Color
  var opacity: Double = 0.75
  var borderColor: Color? = nil
  var padding: CGFloat = 12.0

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .padding(padding)
        .background(bgColor.opacity(self.opacity))
        .foregroundColor(.white)
        .font(.title)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(borderColor ?? bgColor, lineWidth: 2))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .foregroundColor(.primary)
        .animation(.spring())

/*
        .padding(20)
        .background(
            ZStack {
              RoundedRectangle(cornerRadius: 10, style: .continuous)
                  .shadow(color: .white, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? -5: -15, y: configuration.isPressed ? -5: -15)
                  .shadow(color: .black, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? 5: 15, y: configuration.isPressed ? 5: 15)
                  .blendMode(.overlay)
              RoundedRectangle(cornerRadius: 10, style: .continuous)
                  .fill(bgColor)
            }
        )
*/
  }
}
