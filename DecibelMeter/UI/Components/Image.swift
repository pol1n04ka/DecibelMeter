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
        case chevron
        case timeIcon
        case feedbackIcon
        case privacyIcon
        case documentIcon
        case playIcon
        case shareIcon
        case ratingBack
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
        case .chevron:
            self.image = UIImage(named: "Chevron")
        case .timeIcon:
            self.image = UIImage(named: "Clock")
        case .feedbackIcon:
            self.image = UIImage(named: "Feedback")
        case .privacyIcon:
            self.image = UIImage(named: "Privacy")
        case .documentIcon:
            self.image = UIImage(named: "Document")
        case .playIcon:
            self.image = UIImage(named: "Play")
        case .shareIcon:
            self.image = UIImage(named: "Share")
        case .ratingBack:
            self.image = UIImage(named: "RatingBack")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
