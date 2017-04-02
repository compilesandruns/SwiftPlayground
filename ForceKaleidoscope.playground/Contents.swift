import UIKit
import Foundation
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
    
    var lastPoint: CGPoint!
    var currentPoint: CGPoint!
    
    var kaleidoscope: SKSpriteNode!
    var temp: SKSpriteNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .clear
        
        //Blur effect
//        let effectsNode = SKEffectNode()
//        let filter = CIFilter(name: "CIGaussianBlur")
//        let blurAmount = 10.0
//        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
//        addChild(effectsNode)
        
        //Circle
        kaleidoscope = SKSpriteNode(color: .white, size: CGSize(width: size.height * 0.8, height: size.height * 0.8))
        kaleidoscope.position = CGPoint(x: frame.width * 0.5, y:frame.height * 0.5)
        addChild(kaleidoscope)
        
        //Temp
        temp = SKSpriteNode(color: .clear, size: CGSize(width: size.height * 0.8, height: size.height * 0.8))
        temp.position = CGPoint(x: frame.width * 0.5, y:frame.height * 0.5)
        addChild(temp)


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: temp)
        lastPoint = location
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: temp)
        currentPoint = location
        
        let pathToDraw = CGMutablePath()
        let tempLine = SKShapeNode(path:pathToDraw)
        
        temp.removeAllChildren()
        
        pathToDraw.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        pathToDraw.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
        
        tempLine.path = pathToDraw
        tempLine.strokeColor = .green
        
        temp.addChild(tempLine)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: temp)
        currentPoint = location
        
        let pathToDraw = CGMutablePath()
        let myLine = SKShapeNode(path:pathToDraw)
        
        pathToDraw.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        pathToDraw.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
        
        myLine.path = pathToDraw
        myLine.strokeColor = .blue
        
        kaleidoscope.addChild(myLine)
        
        currentPoint = nil
        lastPoint = nil
    }
    
}

let vc = GameViewController()

PlaygroundPage.current.liveView = vc.view
