//  Created by Anton Klimenko

import Foundation

final class NetworkService {
    private let session: URLSession = .shared
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()
}

extension NetworkService: NetworkServiceProtocol {
    
    typealias DataHandler = (Data?, URLResponse?, Error?) -> Void
    
    func getMatchInfo(completion: @escaping (GetMatchInfoAPIResponse) -> Void) {
        
        let components = URLComponents(string: UrlBuilder.getMatchInfo)
        guard let url = components?.url else { completion(.failure(.unknownError)); return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Сontent-Type")

        let defaultBodyContent = RequestBodyMatchInfo(
            proc: "get_match_info",
            params: ["_p_sport" : 1,
                     "_p_match_id" : 1724836
            ]
        )

        guard let body = try? encoder.encode(defaultBodyContent) else { return }
        request.httpBody = body
        
        let handler: DataHandler = { rawData, response, taskError in
            
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = self.decodeJson(type: MatchInfo.self, from: data)
                if let response = response {
                    completion(.success(response))
                }
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknownError))
            }
        }
        session.dataTask(with: request, completionHandler: handler).resume()
    }
    
    func getMatchLinks(id: Int, completion: @escaping (GetMatchLinksAPIResponse) -> Void) {
        let components = URLComponents(string: UrlBuilder.getMatchLinks)
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Сontent-Type")
        
        let defaultBodyContent = RequestBodyMatchLinks(match_id: id)
        guard let body = try? encoder.encode(defaultBodyContent) else { return }
        
        request.httpBody = body
        
        let handler: DataHandler = { rawData, response, taskError in
            do {
                let data = try self.httpResponse(data: rawData, response: response)
                let response = self.decodeJson(type: [MatchLinksModel].self, from: data)
                if let response = response {
                    completion(response)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        session.dataTask(with: request, completionHandler: handler).resume()
    }
    
    private func httpResponse(data: Data?, response: URLResponse?) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode),
              let data = data else {
            throw NetworkServiceError.networkError
        }
        return data
    }
    
    private func decodeJson<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let result = try decoder.decode(type.self, from: data)
            return result
        } catch {
            print("Ошибка при парсинге данных")
        }
        return nil
    }
}
