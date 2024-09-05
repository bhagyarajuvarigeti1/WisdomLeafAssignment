//
//  MovieTableViewCell.swift
//  WisdomLeafAssignment
//
//  Created by bhagyaraju on 05/09/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var id : String = ""
    var callBack: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(movie: Search){
        self.id = movie.imdbID
        self.backGroundView.layer.cornerRadius = 15
        self.backGroundView.clipsToBounds = true
        self.titleLabel.text = movie.title
        self.releaseDateLabel.text = movie.year
        self.movieImageView.layer.cornerRadius = 25
        self.movieImageView.layer.shadowColor = UIColor.purple.cgColor
        self.movieImageView.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.backGroundView.layer.cornerRadius = 25
        self.backGroundView.layer.borderWidth = 2
        self.backGroundView.layer.masksToBounds = true
        self.backGroundView.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.3).cgColor
        
        if movie.isFavorite {
            self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @IBAction func favoriteButtonPress(_ sender: Any) {
        callBack?(self.id)
    }
    
}
