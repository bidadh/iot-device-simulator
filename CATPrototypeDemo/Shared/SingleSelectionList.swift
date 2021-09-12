/**
 * 
 * @author Arthur Kazemi<bidadh@gmail.com>
 * @date 11/8/20 00:53
 * Copyright (c) 2020 Ericsson. All rights reserved.
 * 
 */

import SwiftUI

struct SingleSelectionList<Item: Identifiable, Content: View>: View {
  var items: [Item]
  @Binding var selectedItem: Item?
  var rowContent: (Item) -> Content

  var body: some View {
    List(items) { item in
      self.rowContent(item)
          .modifier(CheckmarkModifier(checked: item.id == self.selectedItem?.id))
          .contentShape(Rectangle())
          .onTapGesture {
            self.selectedItem = item
          }
    }
  }
}
