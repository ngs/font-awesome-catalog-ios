//
//  DetailView.swift
//  FontAwesomeCatalog
//
//  Created by Atsushi Nagase on 2022/03/19.
//

import SwiftUI
import FontAwesome

struct DetailView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        if let icon = viewModel.selectedIcon {
            VStack {
                Spacer()
                FontAwesomeIcon(icon.awesome, size: 200, style: viewModel.style, pro: viewModel.pro)
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    DetailTableRow(label: "ID", value: icon.info.id)
                    DetailTableRow(label: "Unicode", value: icon.info.unicode)
                }
                Spacer()
            }.padding()
                .navigationTitle(icon.info.label)
        } else {
            EmptyView()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
