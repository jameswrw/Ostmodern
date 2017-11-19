//
//  DetailImageViewCell.swift
//  ostest
//
//  Created by JamesW on 19/11/2017.
//  Copyright © 2017 Maninder Soor. All rights reserved.
//

import UIKit

class DetailImageViewCell: UITableViewCell {

    /// Reuse identifier
    static let identifier = "DetailImageViewCellIdentifier"
    
    @IBOutlet weak var imgBackground : UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
