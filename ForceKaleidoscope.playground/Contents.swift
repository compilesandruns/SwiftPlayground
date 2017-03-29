import UIKit
import SpriteKit

import PlaygroundSupport

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = SKView()
        view.backgroundColor = UIColor.white
        view.frame = CGRect(x: 0, y: 0, width: 480, height: 320)
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
}

class GameScene: SKScene {
    
    let line = SKShapeNode(circleOfRadius: 1.0)
    
//    override func didMove(to view: SKView) {
//        backgroundColor = SKColor.white
//
//        line.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
//
//        addChild(line)
//
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let path = CGMutablePath()
            path.move(to: CGPoint(x: location.x, y: location.y))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let locationInScene = touch.location(in: self)
            var line = SKShapeNode()
            let path = CGMutablePath()
            path.addLine(to: CGPoint(x: locationInScene.x, y: locationInScene.y))
            line.path = path
            line.lineWidth = 4
            line.fillColor = UIColor.red
            line.strokeColor = UIColor.red
            self.addChild(line)
        }
    }
}

let vc = GameViewController()

PlaygroundPage.current.liveView = vc.view
