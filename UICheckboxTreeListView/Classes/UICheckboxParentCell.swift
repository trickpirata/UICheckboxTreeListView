//
//  UICheckboxParentCell.swift
//  UICheckboxTreeListView
//
//  Created by Patrick Gorospe on 5/17/19.
//

import UIKit

class UICheckboxParentCell: UITableViewCell {

    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var viewCheckBox: UICheckBox!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        viewCheckBox.style = .indeterminate
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewCheckBox.valueChanged = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAction_action(_ sender: Any) {
        setSelected(!isSelected, animated: true)
    }
}
