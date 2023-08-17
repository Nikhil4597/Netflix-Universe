import Foundation

struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyBLWiZsxFYzC8Lc0du_uYu2pq54MSFzQek"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    
}

enum APIError: Error {
    case failedTogetData
}

class RequestHandler {
    static let shared = RequestHandler()
    
    private init() {}
    
    public func getTrandingMovies(completion: @escaping (Result<[MovieDetails], Error>)-> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data,_,error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(ResponseData.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    public func getTrandingTvShows(completion: @escaping (Result <[MovieDetails], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
                let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }

                    do {
                        let results = try JSONDecoder().decode(ResponseData.self, from: data)
                        completion(.success(results.results))
                    }
                    catch {
                        completion(.failure(APIError.failedTogetData))
                    }
                }
                
                task.resume()
    }
    
    public func getPopularShows(completion: @escaping (Result <[MovieDetails], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
         let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
             guard let data = data, error == nil else {
                 return
             }
             
             do {
                 let results = try JSONDecoder().decode(ResponseData.self, from: data)
                 completion(.success(results.results))
             } catch {
                 print(error.localizedDescription)
             }

         }
         task.resume()
    }
    
    public func getUpcomingShows(completion: @escaping (Result<[MovieDetails], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
                let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    
                    do {
                        let results = try JSONDecoder().decode(ResponseData.self, from: data)
                        completion(.success(results.results))
                    } catch {
                        completion(.failure(APIError.failedTogetData))
                    }
                }
                
                task.resume()
    }
    
    public func getTopRatedShow(completion: @escaping (Result<[MovieDetails], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(ResponseData.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedTogetData))
            }

        }
        task.resume()
    }
    
    public func getDiscoverMovies(completion: @escaping(Result<[MovieDetails], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data,
                  error == nil else {
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
                completion(.success(responseData.results))
                
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    public func getMovie(with query: String, completion: @escaping(Result <VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        
        print("URL \(url)")
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data,
                  error == nil else { return }
            print("Data: \(data[0])")
            do {
                let result = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(result.items[0]))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    public func  search(with query: String, completion: @escaping(Result<[MovieDetails], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
    
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let  data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(ResponseData.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
}
