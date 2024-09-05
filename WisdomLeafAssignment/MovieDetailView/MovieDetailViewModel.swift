//
//  MovieDetailViewModel.swift
//  WisdomLeafAssignment
//
//  Created by bhagyaraju on 05/09/24.
//

import Foundation


class MovieDetailViewModel {
    
    
    private func fetchMovie(url : String,completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = url
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch photos:", error)
                return
            }
            guard let data = data else {
                return
            }
            do {
                let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(.success(movieDetail))
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }

    
    func getMovieDetail(omdbId: String = "tt3896198", completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let url = "https://www.omdbapi.com/?i=\(omdbId)&apikey=e5cea212"
        fetchMovie(url: url) { res in
            completion(res)
        }
    }
}
