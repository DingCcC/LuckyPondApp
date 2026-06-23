import SwiftUI

struct WaterBand: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.12))
        path.addCurve(to: CGPoint(x: rect.width, y: rect.height * 0.08), control1: CGPoint(x: rect.width * 0.28, y: 0), control2: CGPoint(x: rect.width * 0.74, y: rect.height * 0.22))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

struct WaterLines: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for lineIndex in 0..<12 {
            let y = rect.height * (0.18 + CGFloat(lineIndex) * 0.065)
            path.move(to: CGPoint(x: rect.width * 0.08, y: y))
            path.addCurve(to: CGPoint(x: rect.width * 0.92, y: y + CGFloat(lineIndex % 2 == 0 ? 7 : -6)), control1: CGPoint(x: rect.width * 0.35, y: y - 16), control2: CGPoint(x: rect.width * 0.62, y: y + 18))
        }
        return path
    }
}

struct BambooStalks: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for stalkIndex in 0..<4 {
            let x = rect.minX + CGFloat(stalkIndex) * rect.width / 5 + 12
            path.addRoundedRect(in: CGRect(x: x, y: rect.minY, width: 9, height: rect.height), cornerSize: CGSize(width: 4, height: 4))
            for knotIndex in 0..<6 {
                let y = rect.minY + CGFloat(knotIndex) * rect.height / 6
                path.addEllipse(in: CGRect(x: x - 4, y: y, width: 17, height: 5))
            }
        }
        return path
    }
}

struct ShrineRoof: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.28))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.28), control: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.82, y: rect.minY + rect.height * 0.45))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.18, y: rect.minY + rect.height * 0.45))
        path.closeSubpath()
        path.addRoundedRect(in: CGRect(x: rect.minX + rect.width * 0.26, y: rect.minY + rect.height * 0.45, width: rect.width * 0.48, height: rect.height * 0.48), cornerSize: CGSize(width: 6, height: 6))
        return path
    }
}
