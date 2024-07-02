//
//  PrimaryCell.swift
//  AirIndiaHangar
//
//  Created by E5000848 on 01/07/24.
//

import UIKit

class PrimaryCell: UITableViewCell {
    
    static let cellIdentifier = "PrimaryCell"
    
    @IBOutlet weak var defectImageView: UIImageView!
    @IBOutlet weak var defectNameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataInCell(cellContent: CellContent) {
        defectNameLabel.text = cellContent.defectName
        defectImageView.image = cellContent.image
    }

}
