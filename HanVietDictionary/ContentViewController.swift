//
//  ContentViewController.swift
//  HanVietDictionary
//
//  Created by Alex Do on 6/2/26.
//

import UIKit

class TestView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        backgroundColor = .red
    }
}

class ContentViewController: UIViewController {
    let testView = TestView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let barButtonImage = UIImage(systemName: "line.horizontal.3")
        let barButtonItem = UIBarButtonItem(image: barButtonImage, style: .plain, target: self, action: #selector(handleMenuTapped))
        navigationItem.setLeftBarButton(barButtonItem, animated: false)
    }
    
    @objc private func handleMenuTapped() {
        print("Menu tapped")
    }
}
