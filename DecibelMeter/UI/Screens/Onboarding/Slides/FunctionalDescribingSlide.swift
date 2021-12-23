//
//  FunctionalDescribingSlide.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/20/21.
//

import UIKit


class FunctionalDescribingSlide: UICollectionViewCell {
    
    public static let identifier = "FunctionalDescribingSlide"
    
    lazy var image   = ImageView(image: .soundLevels)
    lazy var heading = Label(style: .heading, "SAVING SOUND LEVEL MEASUREMENTS")
    lazy var body    = Label(style: .body, "Save and export recorded sound measurements")
    
    lazy var stackView = StackView(axis: .vertical)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension FunctionalDescribingSlide {
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(heading)
        stackView.addArrangedSubview(body)
        
        stackView.setCustomSpacing(-5, after: image)
        stackView.setCustomSpacing(10, after: heading)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        heading.translatesAutoresizingMaskIntoConstraints = false
        body.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

