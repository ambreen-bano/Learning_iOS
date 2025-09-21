//
//  TableViewCell.swift
//  iOSDesignPatterns_Factory
//
//  Created by Ambreen Bano on 26/08/25.
//

import Foundation
import UIKit

protocol notifyParentAboutBtnTapped: AnyObject {
    func didTapButton()
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    weak var delegate: notifyParentAboutBtnTapped? //View uses delegate to notify VC about Btn Tapped
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func BtnTapped(_ sender: Any) {
        delegate?.didTapButton()
    }
    
}
