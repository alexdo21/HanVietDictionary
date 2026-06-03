////
////  ViewController.swift
////  HanVietDictionary
////
////  Created by Alex Do on 5/30/26.
////
//
//import UIKit
//
//class TestView: UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
//    func setupViews() {
//        backgroundColor = .red
//    }
//}
//
//class ViewController: UIViewController {
//    let testView = TestView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(testView)
//        testView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
//    }
//
//}
//
//extension UIView {
//    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
//        translatesAutoresizingMaskIntoConstraints = false
//        
//        if let top = top {
//            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
//        }
//        if let left = left {
//            leftAnchor.constraint(equalTo: left, constant: padding.left).isActive = true
//        }
//        if let bottom = bottom {
//            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
//        }
//        if let right = right {
//            rightAnchor.constraint(equalTo: right, constant: -padding.right).isActive = true
//        }
//        if size.width != 0 {
//            widthAnchor.constraint(equalToConstant: size.width).isActive = true
//        }
//        if size.height != 0 {
//            heightAnchor.constraint(equalToConstant: size.height).isActive = true
//        }
//    }
//}
