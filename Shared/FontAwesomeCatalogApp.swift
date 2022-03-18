//
//  FontAwesomeCatalogApp.swift
//  Shared
//
//  Created by Atsushi Nagase on 2022/03/19.
//

import SwiftUI

@main
struct FontAwesomeCatalogApp: App {
    @StateObject var viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
