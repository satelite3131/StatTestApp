//  Created by Anton Klimenko

import UIKit
import AVKit

class MatchScreenViewController: UIViewController {
    var presenter: MatchScreenPresenterProtocol!
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray2
        return label
    }()
    
    let tournamentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    let team1Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let team2Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 7
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        presenter.getMatchInfo()
        configureUI()
    }
    
    func configureUI() {
        self.navigationItem.title = "Экран матча"
        view.addSubview(dateLabel)
        view.addSubview(scoreLabel)
        view.addSubview(team1Label)
        view.addSubview(team2Label)
        view.addSubview(tournamentLabel)
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            scoreLabel.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            team1Label.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -7),
            team1Label.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            team2Label.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 7),
            team2Label.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            tournamentLabel.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor),
            tournamentLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 15),
            stackView.topAnchor.constraint(equalTo: tournamentLabel.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor)
        ])
    }
    
    @objc func tvButtonPressed(_ button : UIButton) {
        let url = presenter.matchModel[0].url[button.tag]
        guard let videoURL = URL(string: url) else { return }
        let player = AVPlayer(url: videoURL)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        self.navigationController?.present(playerVC, animated: true, completion: {
            playerVC.player?.play()
        })
    }
}

extension MatchScreenViewController: MatchScreenViewProtocol {
    func onGetMatchDataSuccess() {
        let model = presenter.matchModel[0]
        dateLabel.text = model.date
        tournamentLabel.text = model.tournament
        team1Label.text = model.firstTeamName.name
        team2Label.text = model.secondTeamName.name
        scoreLabel.text = "\(model.firstTeamName.score) : \(model.secondTeamName.score)"
        configureStackView(urls: model.url)
    }
    
    func onGetMatchDataFailure(error: NetworkServiceError) {
    }
    
    private func configureStackView(urls: [String]) {
        for (index, _) in urls.enumerated() {
            stackView.addArrangedSubview(drawButtonWithTag(tag: index))
        }
    }
    
    private func drawButtonWithTag(tag: Int) -> UIButton {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 10
        btn.setTitle("📺", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.tag = tag
        btn.addTarget(self, action: #selector(tvButtonPressed(_:)), for: .touchUpInside)
        return btn
    }
}
