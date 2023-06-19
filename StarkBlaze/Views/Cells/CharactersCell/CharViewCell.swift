//
//  CharViewCell.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import UIKit

class CharViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var cultureLbl: UILabel!
    @IBOutlet weak var birthLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // backview content card customization options
        backView.clipsToBounds = false
        backView.layer.cornerRadius = 15
        backView.backgroundColor = UIColor.white
        
        // Add shadow
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.2
        backView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backView.layer.shadowRadius = 10
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configureCell(with character: CharactersModel) {
        nameLbl.attributedText = Helper.shared.makeBold("👤 Name:", character.name)
        genderLbl.attributedText = Helper.shared.makeBold("⚤ Gender:", character.gender)
        cultureLbl.attributedText = Helper.shared.makeBold("🎭 Culture:", character.culture)
        birthLbl.attributedText = Helper.shared.makeBold("🎂 Born:", character.born)

    
    }
    
}
