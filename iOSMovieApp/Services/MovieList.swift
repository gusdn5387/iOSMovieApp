//
//  MovieList.swift
//  iOSMovieApp
//
//  Created by 박현우 on 2022/06/15.
//

import Foundation
import Alamofire

class MovieList {
    let display = 10 // n개 노출
    let start = 1 // 시작 지점
    
    func getMovieList(_ search: Search?, completion: @escaping ([Item]) -> Void) {
        let query = search?.query ?? "쥬라기"
        let genre = search?.genre ?? 0
        
        var url = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&display=\(display)&start=\(start)&genre=\(genre)"
        
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "rEMQnbLOpQcPKX5lgZf4",
            "X-Naver-Client-Secret": "6BhYa_dxJq"
        ]
        
        AF.request(url, headers: headers)
            .responseData { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success:
                    if let jsonData = response.value {
                        let decoder = JSONDecoder()
                        
                        guard let movieListData = try? decoder.decode(MovieListData.self, from: jsonData) else { return }
                        
                        completion(movieListData.items)
                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
}
