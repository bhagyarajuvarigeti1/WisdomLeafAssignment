//
//  MovieDetailViewController.swift
//  WisdomLeafAssignment
//
//  Created by bhagyaraju on 05/09/24.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private var movieDetailModel =  MovieDetailViewModel()
    var search: Search?
    var movieDetail: MovieDetail?
    @IBOutlet var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.setUpUI()
        self.detailTableView.showsHorizontalScrollIndicator = false
        self.detailTableView.showsVerticalScrollIndicator = false
        if let omdbId = search?.imdbID {
            movieDetailModel.getMovieDetail(omdbId: omdbId) {[weak self] result in
                switch result {
                case .success(let data):
                    self?.movieDetail = data
                    if let movieImage = self?.search?.movieImage {
                        self?.movieDetail?.movieImage = movieImage
                    }
                    DispatchQueue.main.async {
                        self?.detailTableView.reloadData()
                    }
                case .failure(_):
                    print("failure")
                }
            }
        }
    }
    
    func setUpTableView() {
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.detailTableView.register(UINib(nibName: "MovieDetailSecondTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailSecondTableViewCell")
        self.detailTableView.register(UINib(nibName: "MovieDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailTableViewCell")
        self.detailTableView.separatorStyle = .none
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func setUpUI() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.standardAppearance = appearance
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row ==  0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailTableViewCell", for: indexPath) as? MovieDetailTableViewCell else { return UITableViewCell() }
            cell.configureCell(movieDetails: movieDetail)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailSecondTableViewCell", for: indexPath) as? MovieDetailSecondTableViewCell else { return UITableViewCell() }
            cell.configureCell(movieDetail: movieDetail)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
