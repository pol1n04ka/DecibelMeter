//
//  Subscribe.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import UIKit


class SubscribeView: UIViewController {
    
    private let app = UIApplication.shared.delegate
    
    lazy var image = ImageView(image: .human)
    lazy var heading = Label(style: .heading, "YOUR HEALTH IS ABOVE ALL!")
    lazy var body = Label(style: .body, "Subscribe to unlock all the features, just $3.99/week")
    
    lazy var containerForStack: UIView = {
        let v = UIView()
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        
        return v
    }()
    lazy var mainstackView = StackView(axis: .vertical)
    
    // Stack view
    lazy var stackView = StackView(axis: .horizontal)
    
    // Buttons
    lazy var closeButton           = Button(style: .close, nil)
    lazy var continueButton        = Button(style: ._continue, "Continue")
    lazy var termsOfUseButton      = Button(style: .link, "Terms of Use")
    lazy var privacyPolicyButton   = Button(style: .link, "Privacy Policy")
    lazy var restorePurchaseButton = Button(style: .link, "Restore Purchase")
    
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
    
    init(heading: String = "YOUR HEALTH IS ABOVE ALL!", body: String = "Subscribe to unlock all the features, just $3.99/week") {
        super.init(nibName: nil, bundle: nil)
        
        self.heading.text = heading
        self.body.text = body
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: Setup view
extension SubscribeView {
    
    func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        separatorOne.textAlignment = .center
        separatorOne.textColor = .white
        separatorOne.text = "|"
        separatorOne.font = UIFont(name: "OpenSans-Regular", size: 13)
        
        separatorTwo.textAlignment = .center
        separatorTwo.textColor = .white
        separatorTwo.text = "|"
        separatorTwo.font = UIFont(name: "OpenSans-Regular", size: 13)
        
        closeButton.layer.zPosition = 10
        closeButton.addTarget(self, action: #selector(closeOnboarding), for: .touchUpInside)
        
        // MARK: Go to next page
        continueButton.addTarget(self, action: #selector(closeOnboarding), for: .touchUpInside)
        
        termsOfUseButton.addTarget(self, action: #selector(getTermsOfUse), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(getPrivacyPolicy), for: .touchUpInside)
        restorePurchaseButton.addTarget(self, action: #selector(getRestorePurchase), for: .touchUpInside)
        
        view.addSubview(mainstackView)
        mainstackView.addArrangedSubview(image)
        mainstackView.addArrangedSubview(heading)
        mainstackView.addArrangedSubview(body)
        
        mainstackView.setCustomSpacing(-5, after: image)
        mainstackView.setCustomSpacing(10, after: heading)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        heading.translatesAutoresizingMaskIntoConstraints = false
        body.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(closeButton)
        view.addSubview(continueButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(termsOfUseButton)
        stackView.addArrangedSubview(separatorOne)
        stackView.addArrangedSubview(privacyPolicyButton)
        stackView.addArrangedSubview(separatorTwo)
        stackView.addArrangedSubview(restorePurchaseButton)
        
        let constraints = [
            
            // MARK: Close button
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            mainstackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            mainstackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainstackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // MARK: Continue button
            continueButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -15),
            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // MARK: Stack view
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25)
        ]

        
        NSLayoutConstraint.activate(constraints)
    }
    
}

// MARK: Button actions
extension SubscribeView {
    
    @objc func closeOnboarding() {
        guard let optionalWindow = app?.window else { return }
        guard let window = optionalWindow else { return }
        
        window.rootViewController = TabBar()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { completed in
            print("Close onboarding animation ends")
        })
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
