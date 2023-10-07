//
//  PrimeryCollectionViewCell.swift
//  MarvelDemo
//
//  Created by Admin on 07/10/23.
//

import UIKit

class PrimeryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var charImage: UIImageView!
    @IBOutlet weak var charName: UILabel!
    
    static var name : String {
        return String(describing: self)
    }
    
    static var identifier : UINib {
        return UINib(nibName: name, bundle: Bundle.main)
    }
    
    func config(data:Result) {
        
        charName.text = data.name
        
        let url = (data.thumbnail?.path ?? "") + "." + (data.thumbnail?.thumbnailExtension ?? "jpg")
        
        charImage.loadImage(fromURL: URL(string: url)!)
    }
    
    
    func config(data:ComicModel.Result) {
        
        charName.minimumScaleFactor = 0.8
        charName.text = data.series?.name
        
        let url = (data.thumbnail?.path ?? "") + "." + (data.thumbnail?.thumbnailExtension ?? "jpg")
        
        charImage.loadImage(fromURL: URL(string: url)!)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        charImage.image = UIImage(named: "ic_placeholder")
        
    }
    

}
