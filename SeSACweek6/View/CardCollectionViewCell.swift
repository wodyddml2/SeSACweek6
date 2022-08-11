//
//  CardCollectionViewCell.swift
//  SeSACweek6
//
//  Created by J on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    // 변경되지 않는 UI
    override func awakeFromNib() {
        super.awakeFromNib()
        print("CollectionCell", #function)
        setupUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cardView.contentLabel.text = "A"
    }

    func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 10
        cardView.likeButton.tintColor = .systemPink
    }
}
