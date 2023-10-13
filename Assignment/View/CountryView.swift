//
//  ContentView.swift
//  Assignment
//
//  Created by NamaN  on 13/10/23.
//

import SwiftUI

final class CountryViewModel: ObservableObject {
    
    @Published var countryData : [CountryData] = []
    
    init(){
        try? fetchCountries()
    }
    
    func fetchCountries() throws{
        guard let url = URL(string: "https://countriesnow.space/api/v0.1/countries")
        else{return}
        
        downloadData(fromURL: url) { returnedData in
            if let data = returnedData{
                guard let countryData = try? JSONDecoder().decode(Country.self, from: data)else{return}
                DispatchQueue.main.async {
                    self.countryData = countryData.data
                }
            }
        }
        
        DispatchQueue.global().async {
            self.runLongProcess()
            print("task completed")
        }
    }
    private func runLongProcess() {
            for i in 0..<1000000 {
                print(i)
            }
            print("Long process completed.")
        }
    
    private func downloadData(fromURL url: URL , completionHandler : @escaping(_ data :Data?) -> ()){
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                print("NO DATA")
                completionHandler(nil)
                return
            }
            
            guard error == nil else{
                print("error \(String(describing: error))")
                completionHandler(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                print("INVALID RESPONSE")
                completionHandler(nil)
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else{
                print("STATUS CODE IS \(response.statusCode)")
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }.resume()
    }
}

struct CountryView: View {
    
    @StateObject var viewModel = CountryViewModel()
    @State private var selectedCountryIndex : Int = 0
    
    var selectedCountryCities : [String]{
       guard !viewModel.countryData.isEmpty, viewModel.countryData.indices.contains(selectedCountryIndex) else{
           return []
       }
       return viewModel.countryData[selectedCountryIndex].cities
   }
    
    var body: some View {
        VStack {
            Picker("Select Country", selection: $selectedCountryIndex) {
                ForEach(viewModel.countryData.indices, id : \.self) { index in
                    Text(viewModel.countryData[index].country).tag(index)
                }
            }
            
            NavigationLink(destination: CitiesView(cities: selectedCountryCities)) {
                Text("Show Cities")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Assignment")
    }
}

#Preview {
    NavigationStack{
        CountryView()
    }
}
