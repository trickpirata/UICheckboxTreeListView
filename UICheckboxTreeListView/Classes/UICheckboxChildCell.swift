//
//  UICheckboxChildCell.swift
//  UICheckboxTreeListView
//
//  Created by Patrick Gorospe on 5/18/19.
//

import UIKit

class UICheckboxChildCell: UITableViewCell {

    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var contraintRightMargin: NSLayoutConstraint!
    @IBOutlet weak var viewCheckbox: UICheckBox!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAction_action(_ sender: Any) {
        setSelected(!isSelected, animated: true)
    }
    
}
