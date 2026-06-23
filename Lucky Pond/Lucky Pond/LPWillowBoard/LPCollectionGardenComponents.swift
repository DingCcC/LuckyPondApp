import SwiftUI

struct TabStrip<TabChoice: CaseIterable & Identifiable & TabLabel>: View where TabChoice.AllCases: RandomAccessCollection, TabChoice: Hashable {
    var tabs: TabChoice.AllCases
    @Binding var selected: TabChoice

    var body: some View {
        HStack(spacing: 8) {
            ForEach(tabs) { tab in
                Button {
                    selected = tab
                } label: {
                    Text(tab.label)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(selected == tab ? PondInk.creamText : PondInk.inkText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(RoundedRectangle(cornerRadius: 8).fill(selected == tab ? PondInk.moss : PondInk.parchment))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(PondInk.wood.opacity(0.5), lineWidth: 1))
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(PondPressButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 46)
        .zIndex(20)
    }
}

struct FishAlbumCard: View {
    var koi: KoiPattern
    var trace: KoiTrace?
    var selected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
                    ParchmentPanel(inset: 8) {
                        VStack(spacing: 6) {
                    if trace == nil {
                        LPEmblemSealView(emblem: nil, size: 52)
                    } else {
                        Image(koi.assetName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 74, height: 58)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(PondInk.wood.opacity(0.55), lineWidth: 1))
                    }
                    Text(trace == nil ? "Locked" : koi.name)
                        .font(.caption.weight(.bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                    HStack(spacing: 1) {
                        ForEach(0..<5, id: \.self) { starIndex in
                            Image(systemName: starIndex < koi.rarity.starCount ? "star.fill" : "star")
                                .font(.caption2)
                        }
                    }
                    .foregroundStyle(PondInk.gold)
                }
                .foregroundStyle(PondInk.inkText)
                .frame(maxWidth: .infinity, minHeight: 120)
            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(selected ? PondInk.gold : Color.clear, lineWidth: 3))
        }
        .buttonStyle(PondPressButtonStyle())
    }
}

struct KoiDetailPanel: View {
    var koi: KoiPattern
    var trace: KoiTrace?

    var body: some View {
        ParchmentPanel {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    if trace == nil {
                        LPEmblemSealView(emblem: nil, size: 74)
                    } else {
                        Image(koi.assetName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 116, height: 86)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(PondInk.wood.opacity(0.55), lineWidth: 1))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trace == nil ? "Locked Fish" : koi.name)
                            .font(.system(.title2, design: .serif).weight(.heavy))
                        Text(koi.rarity.rawValue)
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(koi.rarity.brushTint.opacity(0.28)))
                    }
                    Spacer()
                }
                DetailLine(title: "Habitat", text: koi.habitat)
                DetailLine(title: "Emblem", text: koi.emblem.rawValue)
                DetailLine(title: "Best Weight", text: trace == nil ? "--" : String(format: "%.1f kg", trace!.bestWeight))
                DetailLine(title: "Collected", text: trace?.firstCaughtAt?.pondDateText ?? "Not yet")
                Text(koi.bonusEffect)
                    .font(.headline)
                Text(koi.pondLore)
                    .font(.system(.subheadline, design: .serif))
            }
            .foregroundStyle(PondInk.inkText)
        }
    }
}

struct KoiDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    var koi: KoiPattern
    var trace: KoiTrace?

    var body: some View {
        ZStack {
            PondBackdrop(mood: koi.rarity == .elder || koi.rarity == .mystic ? .night : .day)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    Capsule()
                        .fill(PondInk.creamText.opacity(0.72))
                        .frame(width: 46, height: 5)
                        .padding(.top, 10)

                    KoiDetailPanel(koi: koi, trace: trace)

                    if let trace {
                        ParchmentPanel {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Local Record")
                                    .font(.headline)
                                DetailLine(title: "Caught", text: "\(trace.caughtCount)")
                                DetailLine(title: "Best Weight", text: String(format: "%.1f kg", trace.bestWeight))
                                DetailLine(title: "First Seen", text: trace.firstCaughtAt?.pondDateText ?? "--")
                            }
                            .foregroundStyle(PondInk.inkText)
                        }
                    }

                    PondButton(title: "Close", systemImage: "xmark", isPrimary: true) {
                        dismiss()
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
}

struct DetailLine: View {
    var title: String
    var text: String

    var body: some View {
        HStack {
            Text(title)
                .font(.caption.weight(.bold))
            Spacer()
            Text(text)
                .font(.caption.weight(.semibold))
        }
    }
}

struct PondPreview: View {
    @EnvironmentObject private var ledger: RippleLedger
    var selectedDecorID: String
    @Binding var isEditing: Bool
    var previewPulse: Bool = false

    var body: some View {
        WoodPanel {
            GeometryReader { proxy in
                ZStack {
                    Image("premium_pond_day")
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                        .opacity(0.82)
                    LinearGradient(colors: [PondInk.pond.opacity(0.08), PondInk.pondDeep.opacity(0.36)], startPoint: .top, endPoint: .bottom)
                    ForEach(ledger.waterline.pondLayout) { fold in
                        if let decor = DecorNestBook.decor.first(where: { $0.id == fold.decorID }) {
                            Image(decor.assetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 58, height: 58)
                                .rotationEffect(.degrees(fold.rotation))
                                .position(x: proxy.size.width * fold.x, y: proxy.size.height * fold.y)
                                .allowsHitTesting(false)
                        }
                    }
                    if isEditing, let selectedDecor = DecorNestBook.decor.first(where: { $0.id == selectedDecorID }) {
                        Image(selectedDecor.assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 86, height: 86)
                            .opacity(0.94)
                            .scaleEffect(previewPulse ? 1.05 : 0.98)
                            .position(x: proxy.size.width * 0.74, y: proxy.size.height * 0.32)
                            .overlay(
                                Circle()
                                    .stroke(PondInk.gold, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                                    .frame(width: 96, height: 96)
                                    .scaleEffect(previewPulse ? 1.08 : 1)
                                    .opacity(previewPulse ? 0.92 : 0.62)
                                    .position(x: proxy.size.width * 0.74, y: proxy.size.height * 0.32)
                            )
                            .animation(.spring(response: 0.28, dampingFraction: 0.72), value: previewPulse)
                            .allowsHitTesting(false)
                    }
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                            isEditing.toggle()
                        }
                    } label: {
                        Label(isEditing ? "Done" : "Edit", systemImage: isEditing ? "checkmark" : "slider.horizontal.3")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(PondInk.creamText)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 11)
                            .background(Capsule().fill(PondInk.woodDeep.opacity(0.86)))
                            .overlay(Capsule().stroke(PondInk.gold.opacity(0.48), lineWidth: 1))
                    }
                    .buttonStyle(PondPressButtonStyle())
                    .contentShape(Capsule())
                    .position(x: 68, y: 28)
                }
            }
        }
    }
}

struct DecorCard: View {
    @EnvironmentObject private var ledger: RippleLedger
    var decor: DecorNest
    var selected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ParchmentPanel(inset: 8) {
                VStack(spacing: 7) {
                    Image(decor.assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 62, height: 62)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Text(decor.name)
                        .font(.caption.weight(.bold))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Text("+\(decor.harmony) Harmony")
                        .font(.caption2.weight(.bold))
                    Text("x\(ledger.waterline.decorInventory[decor.id, default: 0])")
                        .font(.caption2)
                }
                .foregroundStyle(PondInk.inkText)
                .frame(width: 112, height: 142)
            }
            .scaleEffect(selected ? 1.02 : 1)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(selected ? PondInk.gold : Color.clear, lineWidth: 3))
            .overlay(alignment: .topTrailing) {
                if selected {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(PondInk.moss)
                        .padding(7)
                }
            }
            .shadow(color: selected ? PondInk.gold.opacity(0.26) : .black.opacity(0.10), radius: selected ? 8 : 3, x: 0, y: 3)
        }
        .buttonStyle(PondPressButtonStyle())
        .animation(.spring(response: 0.24, dampingFraction: 0.82), value: selected)
    }
}

struct PondCompactActionButton: View {
    var title: String
    var systemImage: String
    var isPrimary: Bool = false
    var isDisabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 7) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .bold))
                Text(title)
                    .font(.system(.subheadline, design: .serif).weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .foregroundStyle(isDisabled ? PondInk.creamText.opacity(0.45) : PondInk.creamText)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: isPrimary
                                ? [Color(red: 0.42, green: 0.55, blue: 0.16), Color(red: 0.18, green: 0.32, blue: 0.12)]
                                : [Color(red: 0.48, green: 0.27, blue: 0.11), PondInk.woodDeep],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(PondInk.gold.opacity(0.55), lineWidth: 1.1))
            )
            .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(PondPressButtonStyle())
        .opacity(isDisabled ? 0.58 : 1)
    }
}
