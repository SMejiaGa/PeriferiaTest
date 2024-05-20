//
//  Network.swift
//  PeriferiaTest
//
//  Created by Sebastian Mejia on 19/05/24.
//

import Foundation

func registerCredentials() async -> Bool {
    let url = URL(string: "https://api.themoviedb.org/3/account/21278215")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MWVlOTllOWY4NzMyMTMwZGM5M2VmZWFkZDNjZmFmZSIsInN1YiI6IjY2NGEzNzk4YzI5ZTQ0ZWI5ZGNjNGE5OSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.WB3cIdlYM2eis-ssi0xzVuvsymvmtQ83EJjqJZ4gMgM"
    ]

    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print(String(decoding: data, as: UTF8.self))
            return true
        } else {
            print("Error en la respuesta: \(response)")
            return false
        }
    } catch {
        print("Error al realizar la solicitud: \(error.localizedDescription)")
        return false
    }
}



