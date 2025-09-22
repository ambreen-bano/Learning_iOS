//
//  myTableCell.swift
//  API_Call_UsingCompletionHandler
//
//  Created by Ambreen Bano on 21/09/25.
//

import Foundation
import UIKit

class myTableCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    //We have awakeFromNib and prepareForReuse for UIViews() any Xib View (viewDidLoad is for VC and Storyboards)
    override class func awakeFromNib() {
        super.awakeFromNib( )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
