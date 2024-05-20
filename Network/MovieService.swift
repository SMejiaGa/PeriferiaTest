//
//  Network.swift
//  PeriferiaTest
//
//  Created by Sebastian Mejia on 19/05/24.
//

import Foundation

public class MovieService {

    static let shared = MovieService()
    
    func registerCredentials() async {
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
            } else {
                print("Error en la respuesta: \(response)")
            }
        } catch {
            print("Error al realizar la solicitud: \(error.localizedDescription)")
        }
    }
    
    func fetchMovies(isPopular: Bool, includeAdult: Bool, language: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(isPopular ? "popular" : "top_rated")")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: "21278215"),
            URLQueryItem(name: "include_adult", value: includeAdult ? "true" : "false"),
            URLQueryItem(name: "include_video", value: "false"),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
        ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MWVlOTllOWY4NzMyMTMwZGM5M2VmZWFkZDNjZmFmZSIsInN1YiI6IjY2NGEzNzk4YzI5ZTQ0ZWI5ZGNjNGE5OSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.WB3cIdlYM2eis-ssi0xzVuvsymvmtQ83EJjqJZ4gMgM"
            ]

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                    completion(.failure(error))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MovieResponse.self, from: data)
                    completion(.success(response.results))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}


