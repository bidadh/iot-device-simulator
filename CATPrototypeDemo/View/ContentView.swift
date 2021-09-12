//
//  ContentView.swift
//  CATPrototypeDemo
//
//  Created by Arthur Kazemi on 8/8/20.
//  Copyright © 2020 Ericsson. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
  @ObservedObject var vm: MainViewModel
  @State var showingSettings = false
  @EnvironmentObject var settings: Settings

  var body: some View {
    ZStack {
      MapView(vm: self.vm)
          .edgesIgnoringSafeArea(.all)

      if self.vm.needsLocation {
        plusButton()
      }

      buttons()
    }
  }

  private func plusButton() -> some View {
    customButton(
        image: "plus",
        style: CustomButtonStyle(bgColor: .blue, opacity: 0.35)
    ) { self.vm.append() }
  }

  private func extremeAlertButton() -> some View {
    eventButton(criticality: "Extreme", key: "temperatureExceeded", message: "There is a security issue!")
  }

  private func highAlertButton() -> some View {
    eventButton(bgColor: .yellow, criticality: "High", key: "temperatureApproaching", message: "There is a shock alert!")
  }

  private func backToNormalButton() -> some View {
    eventButton(bgColor: .yellow, criticality: "High", key: "shockAlert", message: "All goof!!")
  }

  private func eventButton(
      bgColor: Color = .red,
      criticality: String,
      key: String,
      message: String
      ) -> some View {
    customButton(
        image: "exclamationmark.octagon",
        style: CustomButtonStyle(bgColor: bgColor, opacity: 0.9)
    ) { self.vm.sendEvent(asset: self.settings.currentAsset, criticality: criticality, key: key, message: message) }
        .padding(.trailing)
  }

  private func buttons() -> some View {
    VStack {
      Spacer()

      HStack(alignment: .bottom) {
        VStack(alignment: .center) {
          if vm.isReady && self.settings.currentAsset != nil {
            customButton(image: "arrow.right") { self.vm.start(asset: self.settings.currentAsset, withProfile: self.settings.currentProfile) }
                .padding(.leading)
          }

          if vm.hasLocation {
            customButton(image: "clear") { self.vm.clearLocations() }
          }

          customButton(image: "gear") { self.showingSettings.toggle() }
              .padding(.leading)
              .sheet(isPresented: $showingSettings) {
                SettingsView(showingSettings: self.$showingSettings)
                    .environmentObject(self.settings)
              }
        }

        Spacer()

        if vm.isReady && self.settings.currentAsset != nil {
          VStack(alignment: .center) {
            extremeAlertButton()
            highAlertButton()
            backToNormalButton()
          }
        }
      }
    }
        .onAppear {
          if (self.settings.currentAsset == nil) {
            self.showingSettings.toggle()
          }
        }
  }

  private func customButton(
      image: String,
      style: CustomButtonStyle? = nil,
      action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: image)
    }
        .buttonStyle(style ?? CustomButtonStyle(bgColor: .black))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(vm: MainViewModel())
  }
}
