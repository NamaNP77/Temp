//
//  CitiesView.swift
//  Assignment
//
//  Created by NamaN  on 13/10/23.
//

import SwiftUI

struct CitiesView: View {
    
    let cities : [String]
    
    var body: some View {
        VStack{
            List {
                ForEach(cities, id: \.self) { city in
                    Text(city)
                }
            }
        }
        .navigationTitle("List Of Cities")
    }
}

#Preview {
    NavigationStack{
        CitiesView(cities: [])
    }
}
