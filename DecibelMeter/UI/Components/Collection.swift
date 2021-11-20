//
//  CollectionView.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/20/21.
//

import UIKit


class CollectionView: UICollectionView {
    
    let layout = UICollectionViewFlowLayout()
        
    func setupLayout() {
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
    }
    
    init(delegate: UICollectionViewDelegateFlowLayout, dataSource: UICollectionViewDataSource) {
        super.init(frame: .zero, collectionViewLayout: layout)
        setupLayout()
        
        self.delegate = delegate
        self.dataSource = dataSource
        backgroundColor = .clear
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
