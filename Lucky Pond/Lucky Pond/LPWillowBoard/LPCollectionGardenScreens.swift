import SwiftUI


struct FishAlbumView: View {
    @EnvironmentObject private var ledger: RippleLedger
    @State private var selectedTab: ArchiveTab = .fish
    @State private var selectedKoiID = KoiArchiveBook.patterns[0].id
    @State private var presentedKoi: KoiPattern?
    var openDock: (PondDock) -> Void

    var body: some View {
        PondScreenScaffold(mood: .day, active: .fishAlbum, openDock: openDock) {
            VStack(spacing: 12) {
                HeaderRow(title: "Fish Ledger", subtitle: "Track pond species, emblems, and local records.", openDock: openDock)
                TabStrip(tabs: ArchiveTab.allCases, selected: $selectedTab)
                if selectedTab == .fish {
                    fishAlbum
                } else {
                    archiveSummary
                }
            }
        }
        .sheet(item: $presentedKoi) { koi in
            KoiDetailSheet(koi: koi, trace: ledger.waterline.koiArchive[koi.id])
        }
    }

    private var fishAlbum: some View {
        VStack(spacing: 12) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 10)], spacing: 10) {
                ForEach(KoiArchiveBook.patterns) { koi in
                    let trace = ledger.waterline.koiArchive[koi.id]
                    FishAlbumCard(koi: koi, trace: trace, selected: koi.id == selectedKoiID) {
                        selectedKoiID = koi.id
                        presentedKoi = koi
                        HapticRipple.light(ledger)
                        SoundRipple.tap(ledger)
                    }
                }
            }

            let progress = ledger.collectionProgress
            ParchmentPanel {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ledger Progress")
                        .font(.headline)
                    ProgressWood(current: progress.caught, total: progress.total, height: 16)
                    Text("\(progress.caught) / \(progress.total) fish recorded locally")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(PondInk.inkText)
            }
        }
    }

    private var archiveSummary: some View {
        ParchmentPanel {
            VStack(spacing: 12) {
                LPEmblemSealView(emblem: selectedTab.emblem, size: 72)
                Text(selectedTab.summaryTitle)
                    .font(.system(.title2, design: .serif).weight(.bold))
                Text(selectedTab.summaryLine)
                    .font(.system(.body, design: .serif))
                    .multilineTextAlignment(.center)
                PondButton(title: selectedTab.actionTitle, systemImage: selectedTab.actionIcon, isPrimary: true) {
                    openDock(selectedTab.destination)
                }
            }
            .foregroundStyle(PondInk.inkText)
        }
    }
}

struct PondDecorationView: View {
    @EnvironmentObject private var ledger: RippleLedger
    @State private var selectedCategory: DecorCategory = .plants
    @State private var selectedDecorID = "lotus_cluster"
    @State private var toastMessage: String?
    @State private var isEditingPond = false
    @State private var previewPulse = false
    var openDock: (PondDock) -> Void

    var body: some View {
        PondScreenScaffold(
            mood: .day,
            active: .pondGarden,
            openDock: openDock,
            contentBottomPadding: 18
        ) {
            VStack(spacing: 12) {
                HeaderRow(title: "Pond Decoration", subtitle: "Design your pond, attract luck.", openDock: openDock)

                PondPreview(selectedDecorID: selectedDecorID, isEditing: $isEditingPond, previewPulse: previewPulse)
                    .frame(height: 220)

                ParchmentPanel {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Pond Harmony")
                                .font(.headline)
                            Spacer()
                            Text("\(ledger.waterline.reedVault.harmony)/\(ledger.harmonyGoal)")
                                .font(.headline)
                        }
                        ProgressWood(current: ledger.waterline.reedVault.harmony, total: ledger.harmonyGoal, height: 16)
                        Text("Great Harmony: +\(min(40, ledger.waterline.reedVault.harmony / 4))% Luck Bonus")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(PondInk.inkText)
                }

                Picker("Decor Category", selection: $selectedCategory) {
                    ForEach(DecorCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(DecorNestBook.decor.filter { $0.category == selectedCategory }) { decor in
                            DecorCard(decor: decor, selected: decor.id == selectedDecorID) {
                                selectedDecorID = decor.id
                                isEditingPond = true
                                previewPulse.toggle()
                                HapticRipple.light(ledger)
                                SoundRipple.tap(ledger)
                                showToast("\(decor.name) previewing")
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(height: 158)
            }
        } bottomAccessory: {
            decorationActionBar
        }
    }

    private var selectedDecor: DecorNest? {
        DecorNestBook.decor.first(where: { $0.id == selectedDecorID })
    }

    private var decorationActionBar: some View {
        ZStack(alignment: .top) {
            if let toastMessage {
                PondToast(message: toastMessage)
                    .offset(y: -42)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if let decor = selectedDecor {
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        PondCompactActionButton(title: "Place", systemImage: "hand.point.up.left.fill", isPrimary: true) {
                            let ownedCount = ledger.waterline.decorInventory[decor.id, default: 0]
                            let usedCount = ledger.waterline.pondLayout.filter { $0.decorID == decor.id }.count
                            guard ownedCount > usedCount else {
                                HapticRipple.light(ledger)
                                SoundRipple.tap(ledger)
                                showToast("No stored piece")
                                return
                            }
                            isEditingPond = true
                            ledger.placeDecor(decor)
                            previewPulse.toggle()
                            HapticRipple.bloom(ledger)
                            SoundRipple.bloom(ledger)
                            showToast("Placed in pond")
                        }
                        PondCompactActionButton(title: "Rotate", systemImage: "arrow.triangle.2.circlepath") {
                            guard ledger.waterline.pondLayout.isEmpty == false else {
                                HapticRipple.light(ledger)
                                SoundRipple.tap(ledger)
                                showToast("Place a piece first")
                                return
                            }
                            isEditingPond = true
                            ledger.rotateLastDecor()
                            previewPulse.toggle()
                            HapticRipple.light(ledger)
                            SoundRipple.tap(ledger)
                            showToast("Rotated last piece")
                        }
                        PondCompactActionButton(title: "Upgrade", systemImage: "arrow.up.circle.fill", isDisabled: !ledger.hasMaterials(decor.materialNeed) || ledger.waterline.reedVault.coins < decor.upgradeCoins) {
                            guard ledger.waterline.reedVault.coins >= decor.upgradeCoins else {
                                HapticRipple.light(ledger)
                                SoundRipple.tap(ledger)
                                showToast("Need \(decor.upgradeCoins) coins")
                                return
                            }
                            guard ledger.hasMaterials(decor.materialNeed) else {
                                HapticRipple.light(ledger)
                                SoundRipple.tap(ledger)
                                showToast("Need build materials")
                                return
                            }
                            ledger.upgradeDecor(decor)
                            previewPulse.toggle()
                            HapticRipple.bloom(ledger)
                            SoundRipple.bloom(ledger)
                            showToast("Upgraded +\(decor.harmony)")
                        }
                    }
                    HStack(spacing: 10) {
                        PondCompactActionButton(title: "Storehouse", systemImage: "shippingbox.fill") {
                            HapticRipple.light(ledger)
                            SoundRipple.tap(ledger)
                            openDock(.supplies)
                        }
                        PondCompactActionButton(title: "Save", systemImage: "square.and.arrow.down.fill", isPrimary: true) {
                            isEditingPond = false
                            ledger.saveRipple()
                            HapticRipple.bloom(ledger)
                            SoundRipple.bloom(ledger)
                            showToast("Saved locally")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                                openDock(.home)
                            }
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 9)
                .padding(.bottom, 9)
                .background(
                    LinearGradient(colors: [PondInk.pondDeep.opacity(0.98), PondInk.woodDeep.opacity(0.98)], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea(edges: .horizontal)
                )
                .overlay(Rectangle().fill(PondInk.gold.opacity(0.28)).frame(height: 1), alignment: .top)
            }
        }
    }

    private func showToast(_ message: String) {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
            toastMessage = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
            if toastMessage == message {
                withAnimation(.easeOut(duration: 0.2)) {
                    toastMessage = nil
                }
            }
        }
    }
}
