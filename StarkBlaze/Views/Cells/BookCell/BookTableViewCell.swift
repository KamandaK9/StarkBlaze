//
//  BookTableViewCell.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var pagesLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var publishLbl: UILabel!
    @IBOutlet weak var releasedLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // backview content card customization options
        backview.clipsToBounds = false
        backview.layer.cornerRadius = 10
        backview.backgroundColor = UIColor.white
        
        // Add shadow
        backview.layer.shadowColor = UIColor.black.cgColor
        backview.layer.shadowOpacity = 0.2
        backview.layer.shadowOffset = CGSize(width: 5, height: 5)
        backview.layer.shadowRadius = 10
    
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    // Function to configure cell and match model to labels
    func configureCell(with book: BookModel) {
        titleLbl.attributedText = Helper.shared.makeBold("📖 Title:", book.name)
        pagesLbl.attributedText = Helper.shared.makeBold("📚 No. of pages:", "\(book.numberOfPages) pages")
        countryLbl.attributedText = Helper.shared.makeBold("🌍 Published in:", book.country)
        publishLbl.attributedText = Helper.shared.makeBold("📅 Published by:", book.publisher)
        releasedLbl.attributedText = Helper.shared.makeBold("🚀 Released on:", Helper.shared.formatDate(date: book.released))
    }

 

    
    
   

}
