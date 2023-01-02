//
//  ProjectFileCollecrtionView.swift
//  TA
//
//  Created by Designer on 13/12/21.
//

import UIKit

class ProjectFileCollecrtionView: UICollectionViewCell {

    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var projectImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        projectImageView.setRoundCorners(radius: 5.0)
    }

}
