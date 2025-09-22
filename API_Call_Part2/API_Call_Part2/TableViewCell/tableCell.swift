//
//  tableCell.swift
//  ProjP_2025
//
//  Created by Ambreen Bano on 17/07/25.
//

import Foundation
import UIKit


class tableCell : UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellLabel.text = nil
    }
    
    func configureCell(name: String) {
        cellLabel.text = name
    }
}
