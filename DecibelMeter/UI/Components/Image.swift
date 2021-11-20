//
//  Image.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/20/21.
//

import UIKit


class ImageView: UIImageView {
    
    enum Image {
        case progressCircle
        case human
        case rating
        case soundLevels
        case soundMeter
    }
    
    init(image: Image) {
        super.init(frame: .zero)
        
        contentMode = .scaleAspectFit
        clipsToBounds = true
        
        switch image {
        case .progressCircle:
            self.image = UIImage(named: "ProgressCircle")
        case .human:
            self.image = UIImage(named: "Human")
        case .rating:
            self.image = UIImage(named: "Rating")
        case .soundLevels:
            self.image = UIImage(named: "SoundLevels")
        case .soundMeter:
            self.image = UIImage(named: "SoundMeter")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
