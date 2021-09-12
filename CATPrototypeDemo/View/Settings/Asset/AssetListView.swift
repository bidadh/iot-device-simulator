/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 10/8/20 19:43
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import SwiftUI

struct AssetListView: View {
  @ObservedObject var vm: AssetViewModel
  @EnvironmentObject var settings: Settings
  @State var selectedItem: Asset?

  var body: some View {
    SingleSelectionList(items: self.vm.assets, selectedItem: self.$selectedItem) { (item) in
      HStack {
        Text(item.name)
        Spacer()
      }
    }
        .navigationBarTitle(Text("Select Asset"), displayMode: .inline)
        .onAppear {
          self.vm.fetchAssets()
          self.selectedItem = self.settings.currentAsset
        }
        .onDisappear {
          self.settings.currentAsset = self.selectedItem
        }
  }
}
