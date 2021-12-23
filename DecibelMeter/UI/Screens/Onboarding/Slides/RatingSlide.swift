//
//  RatingSlide.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/20/21.
//

import UIKit


class RatingSlide: UICollectionViewCell {
    
    public static let identifier = "RatingSlide"
    
    lazy var image   = ImageView(image: .rating)
    lazy var heading = Label(style: .heading, "HELP US TO IMPROVE OUR APP")
    lazy var body    = Label(style: .body, "We are constantly improving and need your opinion")
    
    lazy var backgroundImage = ImageView(image: .ratingBack)
    
    lazy var stackView = StackView(axis: .vertical)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension RatingSlide {
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(backgroundImage)
        
        addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(heading)
        stackView.addArrangedSubview(body)
        
        stackView.setCustomSpacing(60, after: image)
        stackView.setCustomSpacing(10, after: heading)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        heading.translatesAutoresizingMaskIntoConstraints = false
        body.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            backgroundImage.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -45),
            backgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

