import UIKit
import SpriteKit

class ParticlesView: SKView {
    override func didMoveToSuperview() {
        let scene = SKScene(size: self.frame.size)
        scene.backgroundColor = UIColor.clear
        self.presentScene(scene)
        
        self.allowsTransparency = true
        self.backgroundColor = UIColor.clear
        
        if let particle = SKEmitterNode(fileNamed: "ParticleRane.sks") {
            particle.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)
            particle.particlePositionRange = CGVector(dx: self.bounds.size.width, dy: 0)
            scene.addChild(particle)
        }
    }
    
}
