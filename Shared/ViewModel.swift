//
//  ViewModel.swift
//  FontAwesomeCatalog
//
//  Created by Atsushi Nagase on 2022/03/19.
//

import SwiftUI
import Combine
import FontAwesome

struct Icon {
    let awesome: FontAwesome.Icon
    let info: IconInfo
}

class ViewModel: ObservableObject {
    @Published var allIcons: [Icon] = []
    @Published var icons: [Icon] = []
    @Published var style: FontAwesome.Style = .regular
    @Published var data: Data?
    @Published var pro: Bool = false
    @Published var loading: Bool = false
    @Published var searchText: String = ""
    @Published var selectedIcon: Icon?
    @Published var showDetail: Bool = false
    let styles: [FontAwesome.Style] = [.regular, .light, .thin, .solid, .brands, .duotone]

    var cancellables: [AnyCancellable] = []

    var cacheFileURL: URL? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return cachesDirectory.appendingPathComponent("icons.json")
    }

    init() {
        $data
            .filter { $0 != nil }
            .map {
                (try? JSONDecoder().decode(Response.self, from: $0!))?.data.release.icons.map { info in
                    let icon = FontAwesome.Icon(unicode: info.unicode)

                    if icon == nil {
                        print("Unknown: \(info.label) \(info.unicode)")
                    }
                    return Icon(awesome: icon!, info: info)
                } ?? []
            }
            .assign(to: \.allIcons, on: self)
            .store(in: &cancellables)

        $allIcons
            .combineLatest($pro, $style, $searchText).map { (allIcons, pro, style, searchText) in
                allIcons.filter { icon in
                    let membership = pro ? icon.info.membership.pro : icon.info.membership.free
                    if !membership.contains(Style(awesome: style)) {
                        return false
                    }
                    return (
                        searchText.isEmpty ||
                        icon.info.label.contains(searchText) ||
                        icon.info.id.contains(searchText) ||
                        icon.info.shim?.id.contains(searchText) == true ||
                        icon.info.shim?.name?.contains(searchText) == true
                    )
                }
            }
            .assign(to: \.icons, on: self)
            .store(in: &cancellables)

        $allIcons
            .map { $0.isEmpty }
            .assign(to: \.loading, on: self)
            .store(in: &cancellables)

        $selectedIcon
            .map { $0 != nil }
            .assign(to: \.showDetail, on: self)
            .store(in: &cancellables)
        if
            let url = cacheFileURL, FileManager.default.fileExists(atPath: url.path),
            let data = try? Data(contentsOf: url) {
            self.data = data
        } else {
            try? requestIcons()
        }
    }

    func requestIcons() throws {
        let query = """
            query {
              release(version:"6.1.0"){
                icons {
                  id
                  label
                  membership {
                    free
                    pro
                  }
                  unicode
                  shim {
                    id
                    prefix
                    name
                  }

                }
              }
            }
            """
        var request = URLRequest(url: URL(string: "https://api.fontawesome.com")!)
        request.httpMethod = "POST"
        request.httpBody = try JSONSerialization.data(withJSONObject: ["query": query], options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { (data, _) in
                self.data = data
                if let url = self.cacheFileURL {
                    try? data.write(to: url)
                }
            })
            .store(in: &cancellables)
    }
}
