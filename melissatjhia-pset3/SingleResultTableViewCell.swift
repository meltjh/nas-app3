//
//  SingleResultTableViewCell.swift
//  melissatjhia-pset3
//
//  Created by Melissa Tjhia on 17-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class SingleResultTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.text = "Twilight"
        ratingLabel.text = "5.9"
        
        if let url = NSURL(string: "https://images-na.ssl-images-amazon.com/images/M/MV5BMTQ2NzUxMTAxN15BMl5BanBnXkFtZTcwMzEyMTIwMg@@._V1_SX300.jpg" ) {
            if let poster = NSData(contentsOf: url as URL) {
                self.posterImageView.image = UIImage(data: poster as Data)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
