import SwiftUI

struct LuckyPondLogo: View {
    var compact: Bool = false

    var body: some View {
        ZStack {
            Image("premium_title_board")
                .resizable()
                .scaledToFit()
                .shadow(color: .black.opacity(0.20), radius: 5, x: 0, y: 3)
            VStack(spacing: compact ? -5 : -9) {
                Text("Lucky")
                    .font(.system(size: compact ? 38 : 52, weight: .heavy, design: .serif))
                    .foregroundStyle(PondInk.creamText)
                Text("Pond")
                    .font(.system(size: compact ? 43 : 58, weight: .heavy, design: .serif))
                    .foregroundStyle(Color(red: 0.33, green: 0.72, blue: 0.66))
            }
            .lineLimit(1)
            .minimumScaleFactor(0.68)
            .shadow(color: .black.opacity(0.38), radius: 2, x: 0, y: 2)
            .offset(x: compact ? -24 : -34, y: compact ? -1 : -2)
        }
        .frame(width: compact ? 308 : 360, height: compact ? 124 : 146)
    }
}

struct WoodenTitle: View {
    var title: String
    var subtitle: String?

    var body: some View {
        WoodPanel {
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(.title, design: .serif).weight(.heavy))
                    .foregroundStyle(PondInk.creamText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.58)
                if let subtitle {
                    Text(subtitle)
                        .font(.system(.subheadline, design: .serif).weight(.semibold))
                        .foregroundStyle(PondInk.parchmentLight.opacity(0.92))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.78)
                }
            }
        }
    }
}

struct LPEmblemSealView: View {
    var emblem: LPEmblem?
    var size: CGFloat = 48

    var body: some View {
        ZStack {
            PondGlyphPlateShape()
                .fill(
                    LinearGradient(
                        colors: emblem == nil
                            ? [PondInk.wood.opacity(0.50), PondInk.woodDeep.opacity(0.62)]
                            : [PondInk.wood.opacity(0.98), PondInk.woodDeep.opacity(0.98)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    PondGlyphPlateShape()
                        .stroke(emblem == nil ? PondInk.wood.opacity(0.42) : PondInk.gold.opacity(0.74), lineWidth: emblem == nil ? 1.1 : 1.8)
                )
                .shadow(color: .black.opacity(emblem == nil ? 0.08 : 0.20), radius: 2, x: 0, y: 1)
            PondGlyphPlateShape()
                .fill(
                    LinearGradient(
                        colors: emblem == nil
                            ? [PondInk.parchment.opacity(0.18), PondInk.wood.opacity(0.24)]
                            : [PondInk.pond.opacity(0.95), PondInk.pondDeep.opacity(0.98)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(0.78)
                .overlay(
                    PondGlyphPlateShape()
                        .stroke(PondInk.gold.opacity(emblem == nil ? 0.20 : 0.44), lineWidth: 0.8)
                        .scaleEffect(0.78)
                )
            if let emblem {
                Image(emblem.assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.92, height: size * 0.92)
                    .shadow(color: .black.opacity(0.30), radius: 1, x: 0, y: 1)
            } else {
                PondEmptyGlyphShape()
                    .fill(PondInk.wood.opacity(0.32))
                    .frame(width: size * 0.56, height: size * 0.38)
            }
        }
        .frame(width: size, height: size)
    }
}

struct LPEmblemGlyph: View {
    var emblem: LPEmblem

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            ZStack {
                switch emblem {
                case .lotus:
                    PondLotusGlyph()
                case .tidehook:
                    PondTidehookGlyph()
                case .coin:
                    PondCoinClusterGlyph()
                case .lantern:
                    PondLanternGlyph()
                case .frog:
                    PondLeafGlyph()
                case .pearl:
                    PondPearlGlyph()
                case .bridge:
                    PondBridgeGlyph()
                case .koiCrest:
                    PondKoiGlyph()
                case .reed:
                    PondReedGlyph()
                case .rain:
                    PondRippleGlyph()
                case .bell:
                    PondBellGlyph()
                case .shrine:
                    PondShrineGlyph()
                case .fireSeven, .crystalTripleSeven, .crownBar:
                    Image(emblem.assetName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: side, height: side)
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PondLotusGlyph: View {
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                Capsule()
                    .frame(width: 9, height: 24)
                    .rotationEffect(.degrees(Double(index) * 60))
                    .offset(y: -7)
            }
            Circle().frame(width: 9, height: 9)
        }
    }
}

struct PondTidehookGlyph: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .frame(width: 31, height: 31)
            Rectangle()
                .frame(width: 4, height: 31)
            Rectangle()
                .frame(width: 31, height: 4)
            Path { path in
                path.move(to: CGPoint(x: 8, y: 29))
                path.addQuadCurve(to: CGPoint(x: 30, y: 10), control: CGPoint(x: 26, y: 31))
                path.addQuadCurve(to: CGPoint(x: 22, y: 4), control: CGPoint(x: 31, y: 2))
            }
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .frame(width: 38, height: 34)
        }
    }
}

struct PondCoinClusterGlyph: View {
    var body: some View {
        ZStack {
            ForEach(0..<7, id: \.self) { index in
                Circle()
                    .frame(width: 9, height: 9)
                    .offset(
                        x: CGFloat([0, -10, 10, -5, 5, -14, 14][index]),
                        y: CGFloat([-12, -3, -3, 8, 8, 15, 15][index])
                    )
            }
        }
    }
}

struct PondLanternGlyph: View {
    var body: some View {
        ZStack {
            Capsule().frame(width: 20, height: 28)
            Rectangle().frame(width: 24, height: 4).offset(y: -16)
            Rectangle().frame(width: 18, height: 4).offset(y: 16)
            Rectangle().frame(width: 4, height: 8).offset(y: 23)
        }
    }
}

struct PondLeafGlyph: View {
    var body: some View {
        ZStack {
            PondLeafShape()
                .frame(width: 32, height: 26)
                .rotationEffect(.degrees(-18))
            Path { path in
                path.move(to: CGPoint(x: 8, y: 23))
                path.addQuadCurve(to: CGPoint(x: 28, y: 7), control: CGPoint(x: 18, y: 10))
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .frame(width: 36, height: 30)
        }
    }
}

struct PondPearlGlyph: View {
    var body: some View {
        ZStack {
            Circle().frame(width: 30, height: 30)
            Circle()
                .fill(Color.white.opacity(0.72))
                .frame(width: 9, height: 9)
                .offset(x: -6, y: -7)
        }
    }
}

struct PondBridgeGlyph: View {
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 4, y: 25))
                path.addQuadCurve(to: CGPoint(x: 36, y: 25), control: CGPoint(x: 20, y: 4))
            }
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            ForEach([10, 20, 30], id: \.self) { x in
                Rectangle().frame(width: 3, height: 12).offset(x: CGFloat(x - 20), y: 8)
            }
        }
        .frame(width: 40, height: 40)
    }
}

struct PondKoiGlyph: View {
    var body: some View {
        ZStack {
            Ellipse().frame(width: 34, height: 18)
            PondTailGlyph()
                .frame(width: 16, height: 18)
                .offset(x: 19)
            Circle()
                .fill(PondInk.pondDeep)
                .frame(width: 3.5, height: 3.5)
                .offset(x: -11, y: -3)
        }
    }
}

struct PondReedGlyph: View {
    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                Capsule()
                    .frame(width: 4, height: CGFloat(28 - index * 3))
                    .rotationEffect(.degrees(Double(index - 2) * 10))
                    .offset(x: CGFloat(index - 2) * 6, y: CGFloat(index) * 2)
            }
        }
    }
}

struct PondRippleGlyph: View {
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .stroke(lineWidth: 3)
                    .frame(width: CGFloat(20 + index * 10), height: CGFloat(9 + index * 5))
                    .offset(y: CGFloat(index * 8 - 8))
            }
        }
    }
}

struct PondBellGlyph: View {
    var body: some View {
        ZStack {
            PondBellShape().frame(width: 30, height: 30)
            Circle().frame(width: 5, height: 5).offset(y: 14)
        }
    }
}

struct PondShrineGlyph: View {
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 3, y: 14))
                path.addLine(to: CGPoint(x: 20, y: 4))
                path.addLine(to: CGPoint(x: 37, y: 14))
                path.closeSubpath()
            }
            .fill()
            Rectangle().frame(width: 30, height: 4).offset(y: -1)
            ForEach([-9, 0, 9], id: \.self) { x in
                Rectangle().frame(width: 4, height: 19).offset(x: CGFloat(x), y: 10)
            }
            Rectangle().frame(width: 34, height: 4).offset(y: 22)
        }
        .frame(width: 40, height: 40)
    }
}

struct PondLeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.22))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.maxY + rect.height * 0.22))
        path.closeSubpath()
        return path
    }
}

struct PondTailGlyph: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX * 0.74, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct PondBellShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.14, y: rect.maxY - rect.height * 0.18), control: CGPoint(x: rect.maxX - rect.width * 0.04, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.14, y: rect.maxY - rect.height * 0.18))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), control: CGPoint(x: rect.minX + rect.width * 0.04, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct PondGlyphPlateShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.14, y: rect.minY + rect.height * 0.10))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.10, y: rect.minY + rect.height * 0.19), control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.03))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.maxY - rect.height * 0.14), control: CGPoint(x: rect.maxX + rect.width * 0.04, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.18, y: rect.maxY - rect.height * 0.07), control: CGPoint(x: rect.midX, y: rect.maxY + rect.height * 0.05))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.14, y: rect.minY + rect.height * 0.10), control: CGPoint(x: rect.minX - rect.width * 0.04, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct PondEmptyGlyphShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.20, y: rect.minY + rect.height * 0.16), control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.08))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.05, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.20, y: rect.maxY - rect.height * 0.16))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.maxY + rect.height * 0.08))
        path.closeSubpath()
        return path
    }
}

struct ProgressWood: View {
    var current: Int
    var total: Int
    var height: CGFloat = 12

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width * min(1, CGFloat(current) / CGFloat(max(total, 1)))
            ZStack(alignment: .leading) {
                Capsule().fill(PondInk.woodDeep.opacity(0.68))
                Capsule()
                    .fill(LinearGradient(colors: [PondInk.reed, Color(red: 0.32, green: 0.50, blue: 0.15)], startPoint: .leading, endPoint: .trailing))
                    .frame(width: width)
                Text("\(min(current, total))/\(total)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(PondInk.creamText)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: height)
        .overlay(Capsule().stroke(PondInk.wood.opacity(0.7), lineWidth: 1))
    }
}
