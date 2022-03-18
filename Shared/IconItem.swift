//
//  IconItem.swift
//  FontAwesomeCatalog
//
//  Created by Atsushi Nagase on 2022/03/19.
//

import SwiftUI
import FontAwesome

struct IconItem: View {
    let icon: Icon
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 5) {
            Spacer()
            FontAwesomeIcon(icon.awesome, size: 20, style: viewModel.style, pro: viewModel.pro)
            Text(icon.info.label).font(.caption).opacity(0.5)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(selected ? Color.accentColor : Color.clear)
        .foregroundColor(selected ? .white : .primary)
        .cornerRadius(10)
        .onTapGesture {
            viewModel.selectedIcon = icon
        }
    }

    var selected: Bool {
        viewModel.selectedIcon?.info.id == icon.info.id && viewModel.showDetail
    }
}

struct IconItem_Previews: PreviewProvider {
    static var previews: some View {
        IconItem(
            icon: Icon(
                awesome: .flag,
                info: IconInfo(
                    id: "test",
                    label: "Test Flag",
                    membership: Membership(free: [.regular], pro: [.regular, .solid]),
                    shim: nil,
                    unicode: "test"
                )
            )
        )
    }
}
