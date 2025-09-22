//
//  Header.swift
//  API_Call_UsingCompletionHandler
//
//  Created by Ambreen Bano on 21/09/25.
//

import UIKit

class Header: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
