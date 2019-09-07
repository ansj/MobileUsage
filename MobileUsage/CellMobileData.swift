//
//  Cell.swift
//  MobileUsage
//
//  Created by Ananta Sjartuni on 7/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import UIKit

class CellMobileData: UITableViewCell {
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblData: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
