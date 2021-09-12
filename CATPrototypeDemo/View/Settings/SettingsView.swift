//
//  SettingsView.swift
//  CATPrototypeDemo
//
//  Created by Arthur Kazemi on 10/8/20.
//  Copyright © 2020 Ericsson. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  @Binding var showingSettings: Bool
  @EnvironmentObject var settings: Settings

  var alv: some View {
    AssetListView(vm: AssetViewModel(), selectedItem: self.settings.currentAsset)
        .environmentObject(self.settings)
  }
  var plv: some View {
    ProfileListView(selectedItem: self.settings.currentProfile)
        .environmentObject(self.settings)
  }
  var cv: some View {
    ConfigView()
        .environmentObject(self.settings)
  }
  var rows: [SettingItem] {
    [
      SettingItem(id: "1", title: "Directions Profile", view: AnyView(plv)),
      SettingItem(id: "2", title: "Select Asset", view: AnyView(alv)),
      SettingItem(id: "3", title: "Configuration", view: AnyView(cv))
    ]
  }

  var body: some View {
    NavigationView {
      List(rows, id: \.self) { (item: SettingItem) in
        NavigationLink(destination: item.view) {
          Text(item.title)
        }
      }
          .navigationBarTitle("Settings", displayMode: .inline)
          .navigationBarItems(trailing: Button(action: {
            print("Dismissing sheet view...")
            self.showingSettings = false
          }) {
            Text("Done").bold()
          })
    }
  }
}

struct SettingItem: Identifiable, Hashable {
  static func ==(lhs: SettingItem, rhs: SettingItem) -> Bool {
    lhs.id == rhs.id
  }

  var id: String
  let title: String
  let view: AnyView

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct StatefulPreviewWrapper<Value, Content: View>: View {
  @State var value: Value
  var content: (Binding<Value>) -> Content

  public var body: some View {
    content($value)
  }

  public init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
    self._value = State(wrappedValue: value)
    self.content = content
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    StatefulPreviewWrapper(false) {
      SettingsView(showingSettings: $0)
    }
  }
}
