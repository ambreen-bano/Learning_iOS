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
    @Published var onBtnTapped: Bool = false
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onBtnTapped = false
    }
    
    @IBAction func BtnTapped(_ sender: Any) {
        onBtnTapped = true
    }
    
}
