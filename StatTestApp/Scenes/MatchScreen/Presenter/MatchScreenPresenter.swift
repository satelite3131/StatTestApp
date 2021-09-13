//  Created by Anton Klimenko

import Foundation

protocol MatchScreenViewProtocol: AnyObject {
    func onGetMatchDataSuccess()
    func onGetMatchDataFailure(error: NetworkServiceError)
}

protocol MatchScreenPresenterProtocol: AnyObject {
    func getMatchInfo()
    var matchModel: [MatchEntityModel] { get set }
    init(view: MatchScreenViewProtocol, networkService: NetworkServiceProtocol)
}

class MatchScreenPresenter: MatchScreenPresenterProtocol {
    
    weak var view: MatchScreenViewProtocol?
    let networkService: NetworkServiceProtocol
    var matchModel = [MatchEntityModel]()
    private var streamUrls = [String]()
    
    required init(view: MatchScreenViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    func getMatchInfo() {
        networkService.getMatchInfo { [weak self] response in
            guard let self = self else { return }
            self.process(response: response)
        }
    }
    
    private func process(response: GetMatchInfoAPIResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.parseData(data: data)
                self.view?.onGetMatchDataSuccess()
            case .failure(let error):
                self.view?.onGetMatchDataFailure(error: error)
            }
        }
    }
    
    private func parseData(data: MatchInfo) {
        let group = DispatchGroup()
        group.enter()
        networkService.getMatchLinks(id: data.tournament.id) { [weak self] response in
            guard let self = self else { return }
            self.streamUrls = response.map {$0.url}
            group.leave()
        }
        group.wait()
        self.matchModel =  [buildEntityModel(data: data)]
    }
    
    private func buildEntityModel(data: MatchInfo) -> MatchEntityModel {
        let formateDate = convertDate(date: data.date)
        return MatchEntityModel(
            firstTeamName: TeamEntityModel(
                name: data.team1.nameRus,
                score: data.team1.score
            ),
            secondTeamName: TeamEntityModel(
                name: data.team2.nameRus,
                score: data.team2.score
            ),
            date: formateDate,
            tournament: data.tournament.nameRus,
            dateTournament: formateDate,
            score: data.team1.score ,
            url: self.streamUrls
        )
    }
}
