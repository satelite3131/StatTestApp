//  Created by Anton Klimenko

import Foundation

typealias GetMatchInfoAPIResponse = Result<MatchInfo, NetworkServiceError>
typealias GetMatchLinksAPIResponse = [MatchLinksModel]

protocol NetworkServiceProtocol {
    func getMatchInfo(completion: @escaping (GetMatchInfoAPIResponse) -> Void)
    func getMatchLinks(id: Int, completion: @escaping (GetMatchLinksAPIResponse) -> Void)
}
