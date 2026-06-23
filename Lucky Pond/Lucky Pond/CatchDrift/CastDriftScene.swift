import SpriteKit
import SwiftUI

final class CastDriftScene: SKScene {
    private var koiNodes: [SKNode] = []
    private var rippleNodes: [SKShapeNode] = []
    private var lastWeaveTime: TimeInterval = 0

    override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scaleMode = .resizeFill
    }

    override func didMove(to view: SKView) {
        view.allowsTransparency = true
        view.backgroundColor = .clear
        removeAllChildren()
        koiNodes.removeAll()
        paintWater()
        weaveKoi()
        floatLotus()
    }

    override func update(_ currentTime: TimeInterval) {
        guard currentTime - lastWeaveTime > 0.8 else { return }
        lastWeaveTime = currentTime
        for koiNode in koiNodes {
            let softDrift = CGVector(dx: CGFloat.random(in: -14...14), dy: CGFloat.random(in: -7...7))
            let pondMinY = size.height * 0.24
            let pondMaxY = size.height * 0.58
            let nextPoint = CGPoint(
                x: min(max(koiNode.position.x + softDrift.dx, 54), size.width - 54),
                y: min(max(koiNode.position.y + softDrift.dy, pondMinY), pondMaxY)
            )
            koiNode.run(.move(to: nextPoint, duration: Double.random(in: 2.2...3.6)))
        }
    }

    func showCastRipple() {
        let castPoint = CGPoint(x: size.width * CGFloat.random(in: 0.35...0.62), y: size.height * CGFloat.random(in: 0.34...0.58))
        for ringIndex in 0..<3 {
            let ring = SKShapeNode(circleOfRadius: 18 + CGFloat(ringIndex * 8))
            ring.position = castPoint
            ring.strokeColor = UIColor(white: 0.92, alpha: 0.8)
            ring.lineWidth = 2
            ring.fillColor = .clear
            addChild(ring)
            rippleNodes.append(ring)
            ring.run(.sequence([
                .group([
                    .scale(to: 2.7, duration: 0.8 + Double(ringIndex) * 0.1),
                    .fadeOut(withDuration: 0.8 + Double(ringIndex) * 0.1)
                ]),
                .removeFromParent()
            ]))
        }
    }

    func celebrateCatch(emblem: LPEmblem, name: String) {
        showCastRipple()
        let seal = SKShapeNode(rectOf: CGSize(width: 170, height: 112), cornerRadius: 20)
        seal.fillColor = UIColor(red: 0.92, green: 0.76, blue: 0.50, alpha: 0.94)
        seal.strokeColor = UIColor(red: 0.42, green: 0.23, blue: 0.09, alpha: 1)
        seal.lineWidth = 3
        seal.position = CGPoint(x: size.width * 0.5, y: size.height * 0.53)
        seal.zPosition = 8
        seal.setScale(0.2)
        addChild(seal)

        let emblemDisc = SKShapeNode(circleOfRadius: 28)
        emblemDisc.fillColor = UIColor(red: 0.99, green: 0.86, blue: 0.59, alpha: 1)
        emblemDisc.strokeColor = emblem.uiColor
        emblemDisc.lineWidth = 2.5
        emblemDisc.position = CGPoint(x: 0, y: 20)
        emblemDisc.zPosition = 1
        seal.addChild(emblemDisc)

        let emblemLetter = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        emblemLetter.text = emblem.shortCode
        emblemLetter.fontSize = 24
        emblemLetter.fontColor = emblem.uiColor
        emblemLetter.verticalAlignmentMode = .center
        emblemLetter.horizontalAlignmentMode = .center
        emblemLetter.position = .zero
        emblemLetter.zPosition = 2
        emblemDisc.addChild(emblemLetter)

        let catchLine = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        catchLine.text = name
        catchLine.fontSize = 14
        catchLine.fontColor = UIColor(red: 0.20, green: 0.10, blue: 0.06, alpha: 1)
        catchLine.position = CGPoint(x: 0, y: -50)
        catchLine.zPosition = 1
        seal.addChild(catchLine)

        seal.run(.sequence([
            .group([
                .scale(to: 1.0, duration: 0.18),
                .rotate(byAngle: 0.12, duration: 0.18)
            ]),
            .wait(forDuration: 0.7),
            .group([
                .fadeOut(withDuration: 0.3),
                .scale(to: 1.35, duration: 0.3)
            ]),
            .removeFromParent()
        ]))
    }

    private func paintWater() {
        for rippleIndex in 0..<14 {
            let ripple = SKShapeNode(ellipseOf: CGSize(width: CGFloat.random(in: 70...190), height: CGFloat.random(in: 10...24)))
            ripple.position = CGPoint(x: CGFloat.random(in: 0...max(size.width, 1)), y: CGFloat.random(in: size.height * 0.18...max(size.height * 0.78, 80)))
            ripple.strokeColor = UIColor(red: 0.73, green: 0.93, blue: 0.86, alpha: 0.18)
            ripple.lineWidth = 1.2
            ripple.fillColor = .clear
            ripple.zPosition = 1
            addChild(ripple)
            ripple.run(.repeatForever(.sequence([
                .fadeAlpha(to: 0.04, duration: Double.random(in: 1.4...2.4)),
                .fadeAlpha(to: 0.22, duration: Double.random(in: 1.4...2.4))
            ])))
            ripple.name = "ripple_\(rippleIndex)"
        }
    }

    private func weaveKoi() {
        let koiSprites: [(emblem: LPEmblem, color: UIColor)] = [
            (.lotus, UIColor(red: 0.93, green: 0.48, blue: 0.56, alpha: 1)),
            (.tidehook, UIColor(red: 0.86, green: 0.82, blue: 0.64, alpha: 1)),
            (.coin, UIColor(red: 0.92, green: 0.64, blue: 0.24, alpha: 1)),
            (.frog, UIColor(red: 0.58, green: 0.72, blue: 0.42, alpha: 1)),
            (.lantern, UIColor(red: 0.94, green: 0.72, blue: 0.42, alpha: 1)),
            (.pearl, UIColor(red: 0.76, green: 0.86, blue: 0.90, alpha: 1)),
            (.reed, UIColor(red: 0.52, green: 0.64, blue: 0.28, alpha: 1))
        ]
        for koiIndex in 0..<6 {
            let koiSprite = koiSprites[koiIndex % koiSprites.count]
            let koiNode = SKNode()
            let pondMinY = size.height * 0.18
            let pondMaxY = size.height * 0.70
            koiNode.position = CGPoint(x: CGFloat.random(in: 54...max(size.width - 54, 60)), y: CGFloat.random(in: pondMinY...max(pondMaxY, pondMinY + 8)))
            koiNode.zPosition = 3
            let bodySize = CGSize(width: CGFloat.random(in: 48...66), height: CGFloat.random(in: 22...30))
            let body = SKShapeNode(ellipseOf: bodySize)
            body.fillColor = koiSprite.color.withAlphaComponent(0.48)
            body.strokeColor = UIColor.white.withAlphaComponent(0.22)
            body.lineWidth = 1
            koiNode.addChild(body)

            let tail = SKShapeNode()
            let tailPath = CGMutablePath()
            tailPath.move(to: CGPoint(x: bodySize.width * 0.34, y: 0))
            tailPath.addLine(to: CGPoint(x: bodySize.width * 0.56, y: bodySize.height * 0.42))
            tailPath.addLine(to: CGPoint(x: bodySize.width * 0.56, y: -bodySize.height * 0.42))
            tailPath.closeSubpath()
            tail.path = tailPath
            tail.fillColor = koiSprite.color.withAlphaComponent(0.42)
            tail.strokeColor = .clear
            koiNode.addChild(tail)

            koiNode.run(.repeatForever(.sequence([
                .rotate(byAngle: CGFloat.random(in: -0.06...0.06), duration: 1.8),
                .rotate(byAngle: CGFloat.random(in: -0.06...0.06), duration: 1.8)
            ])))
            addChild(koiNode)
            koiNodes.append(koiNode)
        }
    }

    private func floatLotus() {
        let decorTextures = ["decor_lotus_cluster", "decor_lotus_bud", "decor_reed_patch", "decor_water_grass"]
        for decorIndex in 0..<4 {
            let textureName = decorTextures[decorIndex % decorTextures.count]
            let decor = SKSpriteNode(imageNamed: textureName)
            let side = CGFloat.random(in: 30...48)
            decor.size = CGSize(width: side, height: side)
            let pondMinY = size.height * 0.18
            let pondMaxY = size.height * 0.68
            decor.position = CGPoint(x: CGFloat.random(in: 28...max(size.width - 28, 32)), y: CGFloat.random(in: pondMinY...max(pondMaxY, pondMinY + 8)))
            decor.alpha = CGFloat.random(in: 0.26...0.42)
            decor.zPosition = 2
            decor.name = "floating_decor_\(decorIndex)"
            addChild(decor)
            decor.run(.repeatForever(.sequence([
                .moveBy(x: CGFloat.random(in: -8...8), y: CGFloat.random(in: -4...4), duration: 2.5),
                .moveBy(x: CGFloat.random(in: -8...8), y: CGFloat.random(in: -4...4), duration: 2.5)
            ])))
        }
    }
}

private extension LPEmblem {
    var shortCode: String {
        switch self {
        case .koiCrest: return "K"
        case .bridge: return "B"
        default: return String(rawValue.prefix(1))
        }
    }

    var uiColor: UIColor {
        switch self {
        case .lotus: return UIColor(red: 0.95, green: 0.38, blue: 0.53, alpha: 1)
        case .tidehook: return UIColor(red: 0.95, green: 0.82, blue: 0.42, alpha: 1)
        case .coin: return UIColor(red: 0.96, green: 0.64, blue: 0.18, alpha: 1)
        case .lantern: return UIColor(red: 0.96, green: 0.38, blue: 0.19, alpha: 1)
        case .frog: return UIColor(red: 0.45, green: 0.65, blue: 0.22, alpha: 1)
        case .pearl: return UIColor(red: 0.72, green: 0.84, blue: 0.92, alpha: 1)
        case .bridge: return UIColor(red: 0.63, green: 0.31, blue: 0.22, alpha: 1)
        case .koiCrest: return UIColor(red: 0.91, green: 0.50, blue: 0.24, alpha: 1)
        case .reed: return UIColor(red: 0.53, green: 0.64, blue: 0.25, alpha: 1)
        case .rain: return UIColor(red: 0.33, green: 0.62, blue: 0.78, alpha: 1)
        case .bell: return UIColor(red: 0.86, green: 0.64, blue: 0.26, alpha: 1)
        case .shrine: return UIColor(red: 0.73, green: 0.34, blue: 0.28, alpha: 1)
        case .fireSeven: return UIColor(red: 1.00, green: 0.35, blue: 0.07, alpha: 1)
        case .crystalTripleSeven: return UIColor(red: 0.22, green: 0.72, blue: 1.00, alpha: 1)
        case .crownBar: return UIColor(red: 0.96, green: 0.68, blue: 0.20, alpha: 1)
        }
    }
}
