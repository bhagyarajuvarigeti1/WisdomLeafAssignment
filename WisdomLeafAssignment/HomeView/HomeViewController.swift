//
//  HomeViewController.swift
//  WisdomLeafAssignment
//
//  Created by bhagyaraju on 05/09/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var homeVM = HomeViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        setupTableView()
        setupViewModel()
        searchBar.placeholder = "Search"
        searchBar.tintColor = .systemGreen
        searchBar.searchTextField.textColor = .systemGreen
        homeVM.delegate = self
    }
    
    private func setupTableView() {
        self.view.backgroundColor = .black
        self.movieTableView.backgroundColor = .clear
        self.movieTableView.dataSource = self
        self.movieTableView.delegate = self
        self.movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        self.movieTableView.showsHorizontalScrollIndicator = false
        self.movieTableView.showsVerticalScrollIndicator = false
    }
    
    private func setupViewModel() {
        self.homeVM.fetchFilter(searchString: "Guard") { response in
            switch response {
            case .success(_) :
                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    private func filterMovies(searchText: String) {
        if searchText.isEmpty {
            self.setupViewModel()
            return
        }
        self.homeVM.fetchFilter(searchString: searchText) { response in
            switch response {
            case .success(_) :
                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
}

extension HomeViewController:  UITableViewDataSource,  UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeVM.movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .black
        var movie = self.homeVM.movie[indexPath.row]
        if self.homeVM.favIds.contains(movie.imdbID) {
            movie.isFavorite = true
        }
        cell.configure(movie: movie)
        cell.favoriteButton.tag = indexPath.item
        cell.callBack = self.homeVM.performFavoriteButton
        if let imageData = movie.movieImage {
            cell.movieImageView.image = imageData
        } else {
            self.homeVM.fetchImage(for: indexPath.row) { [
                weak cell] image
                in DispatchQueue
                    .main.async {
                        cell?.movieImageView?.image = image
                        cell?.setNeedsLayout()
                    }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailMovie = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
        let vm = self.homeVM.movie[indexPath.row]
        detailMovie.search = vm
        detailMovie.movieDetail?.movieImage = vm.movieImage
        self.navigationController?.pushViewController(detailMovie, animated: true)
    }
}
    
// MARK: - Delegation Pattern For Reload TableView

extension HomeViewController: HomeTableViewDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.movieTableView.reloadData()
        }
    }
}

// MARK: - SearchBar Delegate Methods

extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMovies(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
