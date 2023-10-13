//
//  CountryModel.swift
//  Assignment
//
//  Created by NamaN  on 13/10/23.
//

import Foundation

struct Country: Codable {
    let data: [CountryData]
}

struct CountryData: Codable {
    let country: String
    let cities: [String]
}
