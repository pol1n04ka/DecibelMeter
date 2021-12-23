//
//  MainFunctionalSlide.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/20/21.
//

import UIKit


class MainFunctionalSlide: UICollectionViewCell {
    
    public static let identifier = "MainFunctional"
    
    lazy var image   = ImageView(image: .soundMeter)
    lazy var heading = Label(style: .heading, "MEASURE THE SOUND LEVEL")
    lazy var body    = Label(style: .body, "Determine exactly the noise level in decibels, take care of your health and the health of others")
    
    lazy var stackView = StackView(axis: .vertical)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension MainFunctionalSlide {
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(heading)
        stackView.addArrangedSubview(body)
        
        stackView.setCustomSpacing(25, after: image)
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
