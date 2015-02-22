//
//  GameViewController.swift
//  AHPong
//
//  Created by Andrea Houg on 2/21/15.
//  Copyright (c) 2015 a. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: view.bounds.size)
        let skview = view as SKView
        skview.showsFPS = true
        skview.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skview.presentScene(scene)
        
        
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
