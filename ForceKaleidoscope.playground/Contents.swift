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

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
    
    let line = SKShapeNode(circleOfRadius: 5.0)
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .black
        
        //Blur effect
        let effectsNode = SKEffectNode()
        let filter = CIFilter(name: "CIGaussianBlur")
        let blurAmount = 10.0
        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        addChild(effectsNode)
        
        //Circle
        let kaleidoscope = SKSpriteNode(color: .white, size: CGSize(width: size.height * 0.8, height: size.height * 0.8))
        kaleidoscope.position = CGPoint(x: frame.width * 0.5, y:frame.height * 0.5)
        addChild(kaleidoscope)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        line.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        line.strokeColor = .purple
        
        addChild(line)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let forward = SKShapeNode(circleOfRadius: 3)
        forward.strokeColor = .red
        forward.position = line.position
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - forward.position
    
        
        // 5 - OK to add now - you've double checked position
        addChild(forward)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + forward.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        forward.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}

let vc = GameViewController()

PlaygroundPage.current.liveView = vc.view
