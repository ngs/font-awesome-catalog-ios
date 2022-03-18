//
//  DetailTableRow.swift
//  FontAwesomeCatalog
//
//  Created by Atsushi Nagase on 2022/03/19.
//

import SwiftUI

struct DetailTableRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 100, alignment: .leading)
                .font(.callout)
                .foregroundColor(.secondary)
            Button(value) {
#if os(macOS)
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([.string], owner: nil)
                pasteboard.setString(value, forType: .string)
#elseif os(iOS)
                let pasteboard = UIPasteboard.general
                pasteboard.string = value
#else
#endif
            }
        }
    }
}

struct DetailTableRow_Previews: PreviewProvider {
    static var previews: some View {
        DetailTableRow(label: "Test", value: "Foo")
    }
}
