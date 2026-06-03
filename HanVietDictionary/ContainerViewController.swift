//
//  ContainerViewController.swift
//  HanVietDictionary
//
//  Created by Alex Do on 6/2/26.
//

import UIKit

class ContainerViewController: UIViewController {
    private var navigator: UINavigationController!
    private var currViewController: ContentViewController! {
        didSet {
            navigator.setViewControllers([currViewController], animated: false)
        }
    }

    convenience init(rootViewController: ContentViewController) {
        self.init()
        self.navigator = UINavigationController(rootViewController: rootViewController)
        self.currViewController = rootViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(navigator)
        view.addSubview(navigator.view)
        navigator.didMove(toParent: self)

        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = UIColor.rgb(red: 116, green: 157, blue: 157)
        barAppearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]
        navigator.navigationBar.standardAppearance = barAppearance
        navigator.navigationBar.scrollEdgeAppearance = barAppearance
    }
}
