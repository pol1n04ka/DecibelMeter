//
//  Onboarding.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import UIKit
import StoreKit


class OnboardingView: UIViewController {
    
    private let app = UIApplication.shared.delegate
    private var currentIndex: IndexPath = .init(index: 0)
    
    // MARK: UI elements
    // Collection view
    lazy var collectionView = CollectionView(
        delegate: self,
        dataSource: self
    )
    
    // Stack view
    lazy var stackView = StackView(axis: .horizontal)
    
    // Buttons
    lazy var closeButton           = Button(style: .close, nil)
    lazy var continueButton        = Button(style: ._continue, "Continue")
    lazy var termsOfUseButton      = Button(style: .link, "Terms of Use")
    lazy var privacyPolicyButton   = Button(style: .link, "Privacy Policy")
    lazy var restorePurchaseButton = Button(style: .link, "Restore")
    
    // Separators
    lazy var separatorOne = UILabel()
    lazy var separatorTwo = UILabel()
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func rateApp() {
        SKStoreReviewController.requestReview()
    }
    
}


// MARK: Setup view
extension OnboardingView {
    
    func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        separatorOne.textAlignment = .center
        separatorOne.textColor = .black
        separatorOne.text = "|"
        separatorOne.font = UIFont(name: "OpenSans-Regular", size: 13)
        
        separatorTwo.textAlignment = .center
        separatorTwo.textColor = .black
        separatorTwo.text = "|"
        separatorTwo.font = UIFont(name: "OpenSans-Regular", size: 13)
        
        closeButton.isHidden = true
        closeButton.layer.zPosition = 10
        closeButton.addTarget(self, action: #selector(closeOnboarding), for: .touchUpInside)
        
        // MARK: Go to next page
        continueButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        termsOfUseButton.addTarget(self, action: #selector(getTermsOfUse), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(getPrivacyPolicy), for: .touchUpInside)
        restorePurchaseButton.addTarget(self, action: #selector(getRestorePurchase), for: .touchUpInside)
        
        // MARK: Register slides
        collectionView.register(MainFunctionalSlide.self, forCellWithReuseIdentifier: MainFunctionalSlide.identifier)
        collectionView.register(RatingSlide.self, forCellWithReuseIdentifier: RatingSlide.identifier)
        collectionView.register(FunctionalDescribingSlide.self, forCellWithReuseIdentifier: FunctionalDescribingSlide.identifier)
        collectionView.register(SubscribeSlide.self, forCellWithReuseIdentifier: SubscribeSlide.identifier)
        
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(continueButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(termsOfUseButton)
        stackView.addArrangedSubview(separatorOne)
        stackView.addArrangedSubview(restorePurchaseButton)
        stackView.addArrangedSubview(separatorTwo)
        stackView.addArrangedSubview(privacyPolicyButton)
        
        let constraints = [
            
            // MARK: Close button
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // MARK: Collection view
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),
            
            // MARK: Continue button
            continueButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -15),
            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // MARK: Stack view
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        
        NSLayoutConstraint.activate(constraints)
        
        
    }
    
}

// MARK: Button actions
extension OnboardingView {
    
    @objc func closeOnboarding() {
        guard let optionalWindow = app?.window else { return }
        guard let window = optionalWindow else { return }
        
        window.rootViewController = TabBar()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { completed in
            print("Close onboarding animation ends")
        })
        
        OnboardingManager.shared.isFirstLaunch = true
    }
    
    @objc func nextPage() {
        if currentIndex.row < 3 {
            collectionView.scrollToItem(at: IndexPath(arrayLiteral: 0, currentIndex.row + 1), at: .centeredHorizontally, animated: true)
        } else {
            closeOnboarding()
        }
    }
    
    @objc func getTermsOfUse() {
        print("Terms of use")
        
        let url = URL(string: "https://www.google.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func getPrivacyPolicy() {
        print("Privacy policy")
        
        let url = URL(string: "https://www.google.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func getRestorePurchase() {
        print("Restore purchase")
        
        let url = URL(string: "https://www.google.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
}


// MARK: Collection view data source
extension OnboardingView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var slide: String

        switch indexPath.row {
        case 0:
            slide = MainFunctionalSlide.identifier
        case 1:
            slide = RatingSlide.identifier
        case 2:
            slide = FunctionalDescribingSlide.identifier
        case 3:
            slide = SubscribeSlide.identifier
        default:
            slide = MainFunctionalSlide.identifier
        }
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: slide, for: indexPath)
        return item
    }
    
}


// MARK: Collection view delegate
extension OnboardingView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        currentIndex = indexPath
        
        if currentIndex.row == 1 {
            rateApp()
        }
        
        if currentIndex.row == 3 {
            closeButton.isHidden = false
        } else {
            closeButton.isHidden = true
        }
        
        UIView.transition(with: closeButton, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { _ in })
    }
    
}
