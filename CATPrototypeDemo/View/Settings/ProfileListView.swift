/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 20:07
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import SwiftUI
import MapboxDirections

struct ProfileListView: View {
  @EnvironmentObject var settings: Settings
  @State var selectedItem: Profile?

  let profiles: [Profile] = [
    Profile.WALKING,
    Profile.DRIVING,
    Profile.CYCLING
  ]

  var body: some View {
    SingleSelectionList(items: self.profiles, selectedItem: self.$selectedItem) { (item) in
      HStack {
        Text(item.title)
        Spacer()
      }
    }
        .navigationBarTitle(Text("Select Profile"), displayMode: .inline)
        .onAppear {
          self.selectedItem = self.settings.currentProfile
        }
        .onDisappear {
          guard let selected = self.selectedItem else {
            return
          }

          self.settings.currentProfile = selected
        }
  }
}

struct Profile: Identifiable, Hashable {
  let value: DirectionsProfileIdentifier
  var name: String {
    value.rawValue
  }
  let title: String
  var id: String {
    name
  }

  static let DRIVING = Profile(value: DirectionsProfileIdentifier.automobile, title: "Driving")
  static let CYCLING = Profile(value: DirectionsProfileIdentifier.cycling, title: "Cycling")
  static let WALKING = Profile(value: DirectionsProfileIdentifier.walking, title: "Walking")
}
