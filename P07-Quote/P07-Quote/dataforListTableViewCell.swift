//
//  dataforListTableViewCell.swift
//  P07-Quote
//
//  Created by Rohini Shinde on 12/7/15.
//  Copyright © 2015 Rohini Shinde. All rights reserved.
//

import UIKit






class dataforListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var compNmLbl: UILabel!
    @IBOutlet weak var compFullNmLbl: UILabel!
    @IBOutlet weak var currentValLbl: UILabel!
    @IBOutlet weak var perChangeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
