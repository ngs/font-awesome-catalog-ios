//
//  ContentView.swift
//  Shared
//
//  Created by Atsushi Nagase on 2022/03/19.
//

import SwiftUI
import FontAwesome

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Picker("Style", selection: $viewModel.style) {
                        ForEach(viewModel.styles, id: \.self) { style in
                            Text(style.rawValue.capitalized)
                        }
                    }.pickerStyle(.menu)
                    Toggle("Pro", isOn: $viewModel.pro)
                }.padding()
                if viewModel.loading {
                    VStack {
                        ProgressView().progressViewStyle(.circular).padding()
                    }.frame(maxHeight: .infinity)
                } else {
                    Text("\(viewModel.icons.count) icons available").font(.caption)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 10) {
                            ForEach(viewModel.icons, id: \.info.id) {
                                IconItem(icon: $0)
                            }
                        }.padding()
                    }
                }
                NavigationLink(destination: DetailView(), isActive: $viewModel.showDetail) {
                    EmptyView()
                }.hidden()
            }.searchable(text: $viewModel.searchText).navigationTitle("Icons")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
