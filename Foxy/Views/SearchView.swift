//
//  SearchView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText : String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    
                }
            }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    SearchView()
}
