import SwiftUI

struct LPTackleLoftView: View {
    @EnvironmentObject private var ledger: RippleLedger
    @State private var selectedTab: GearTab = .rods
    @State private var selectedRodID = "mistwake_reedcaster"
    @State private var selectedLineID = "reedglass_trace"
    @State private var selectedFloatID = "bloomcap_bobber"
    var openDock: (PondDock) -> Void

    var body: some View {
        PondScreenScaffold(mood: .night, active: .gear, openDock: openDock) {
            VStack(spacing: 12) {
                HeaderRow(title: "Tackle Loft", subtitle: "Tune rods, traces, floats, and talismans.", openDock: openDock)
                TabStrip(tabs: GearTab.allCases, selected: $selectedTab)
                    .padding(.bottom, 6)
                    .zIndex(30)
                Group {
                    switch selectedTab {
                    case .rods:
                        rodsPane
                    case .lines:
                        linesPane
                    case .floats:
                        floatsPane
                    case .talismans:
                        talismansPane
                    }
                }
                .zIndex(0)
            }
        }
    }

    private var rodsPane: some View {
        VStack(spacing: 12) {
            ForEach(TackleNest.rods) { rod in
                RodRow(rod: rod, selected: selectedRodID == rod.id) {
                    selectedRodID = rod.id
                    ledger.equipRod(rod.id)
                }
            }
            if let rod = TackleNest.rods.first(where: { $0.id == selectedRodID }) {
                RodDetail(rod: rod)
            }
        }
    }

    private var linesPane: some View {
        VStack(spacing: 12) {
            ForEach(TackleNest.lines) { reedLine in
                TackleAccessoryRow(name: reedLine.name, level: ledger.lineLevel(reedLine.id), rarity: reedLine.rarity, emblem: reedLine.emblem, selected: selectedLineID == reedLine.id) {
                    selectedLineID = reedLine.id
                    ledger.equipLine(reedLine.id)
                }
            }
            if let reedLine = TackleNest.lines.first(where: { $0.id == selectedLineID }) {
                LineDetail(reedLine: reedLine)
            }
        }
    }

    private var floatsPane: some View {
        VStack(spacing: 12) {
            ForEach(TackleNest.floats) { pondFloat in
                TackleAccessoryRow(name: pondFloat.name, level: ledger.floatLevel(pondFloat.id), rarity: pondFloat.rarity, emblem: pondFloat.emblem, selected: selectedFloatID == pondFloat.id) {
                    selectedFloatID = pondFloat.id
                    ledger.equipFloat(pondFloat.id)
                }
            }
            if let pondFloat = TackleNest.floats.first(where: { $0.id == selectedFloatID }) {
                FloatDetail(pondFloat: pondFloat)
            }
        }
    }

    private var talismansPane: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(TackleNest.talismans) { talisman in
                TalismanCard(talisman: talisman)
            }
        }
    }
}

struct LotusFestivalView: View {
    @EnvironmentObject private var ledger: RippleLedger
    @State private var selectedTab: FestivalTab = .missions
    var openDock: (PondDock) -> Void

    var body: some View {
        PondScreenScaffold(mood: .festival, active: .festival, openDock: openDock) {
            VStack(spacing: 12) {
                HeaderRow(title: "Bloomtide Run", subtitle: "Gather reedlights and unlock pond rites.", openDock: openDock)
                ParchmentPanel {
                    HStack {
                        LPEmblemSealView(emblem: .lantern, size: 64)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Run Detail")
                                .font(.caption.weight(.bold))
                            Text("6d 12h")
                                .font(.system(.title2, design: .serif).weight(.heavy))
                            Text("Local countdown based on device time")
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .foregroundStyle(PondInk.inkText)
                }
                TabStrip(tabs: FestivalTab.allCases, selected: $selectedTab)
                switch selectedTab {
                case .missions:
                    milestoneList(ledger.festivalMilestones)
                case .rewards:
                    FestivalRewardTrack()
                case .records:
                    LocalRecordPanel()
                }
            }
        }
    }

    private func milestoneList(_ milestones: [WillowMilestone]) -> some View {
        VStack(spacing: 10) {
            ForEach(milestones) { milestone in
                MilestoneRow(
                    milestone: milestone,
                    claimed: ledger.waterline.lotusFestival.claimedMissionMarks.contains(milestone.id),
                    claimKind: .festival
                ) { milestone in
                    HapticRipple.light(ledger)
                    SoundRipple.tap(ledger)
                    openDock(destination(for: milestone.mark))
                }
            }
        }
    }

    private func destination(for mark: PondProgressMark) -> PondDock {
        switch mark {
        case .decorUpgrades, .harmony:
            return .pondGarden
        case .rodUpgrades:
            return .gear
        case .recipes, .unlockedFish:
            return .fishAlbum
        case .loginDays:
            return .home
        case .lanterns:
            return .gameplay
        default:
            return .gameplay
        }
    }
}

struct LPPondMarksView: View {
    @EnvironmentObject private var ledger: RippleLedger
    var openDock: (PondDock) -> Void

    var body: some View {
        PondScreenScaffold(mood: .night, active: .achievements, openDock: openDock) {
            VStack(spacing: 12) {
                HeaderRow(title: "Pond Marks", subtitle: "Local feats earned through real casts.", openDock: openDock)
                SectionTitle("Today on the Water")
                ForEach(ledger.dailyMilestones) { milestone in
                    MilestoneRow(milestone: milestone, claimed: ledger.waterline.claimedDailyMarks.contains(milestone.id), claimKind: .daily)
                }
                SectionTitle("Pond Marks")
                ForEach(ledger.achievementMilestones) { milestone in
                    MilestoneRow(milestone: milestone, claimed: ledger.waterline.claimedAchievementMarks.contains(milestone.id), claimKind: .achievement)
                }
            }
        }
    }
}

struct LPReedStoresView: View {
    @EnvironmentObject private var ledger: RippleLedger
    @State private var selectedTab: SupplyTab = .baits
    var openDock: (PondDock) -> Void

    var body: some View {
        PondScreenScaffold(mood: .day, active: .supplies, openDock: openDock) {
            VStack(spacing: 12) {
                HeaderRow(title: "Reed Stores", subtitle: "Bait bundles, build parts, and pond trade.", openDock: openDock)
                TabStrip(tabs: SupplyTab.allCases, selected: $selectedTab)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(filteredSupplies) { fold in
                        SupplyCard(fold: fold)
                    }
                }
            }
        }
    }

    private var filteredSupplies: [SupplyFold] {
        ledger.supplyFolds.filter { fold in
            switch selectedTab {
            case .baits: return fold.bloomYield.bait.isEmpty == false
            case .materials: return fold.bloomYield.materials.isEmpty == false
            case .talismans: return fold.emblem == .bell || fold.emblem == .tidehook
            case .decor: return fold.emblem == .lantern || fold.emblem == .shrine
            case .trade: return true
            }
        }
    }
}

struct SettingsPondView: View {
    @EnvironmentObject private var ledger: RippleLedger
    @State private var showReset = false
    var openDock: (PondDock) -> Void

    var body: some View {
        PondScreenScaffold(mood: .night, active: .settings, openDock: openDock, contentBottomPadding: 132) {
            VStack(spacing: 12) {
                HeaderRow(title: "Settings", subtitle: "Local preferences and pond notes.", rightSystemImage: "house.fill", rightDock: .home, openDock: openDock)
                ParchmentPanel {
                    VStack(alignment: .leading, spacing: 16) {
                        SliderRow(title: "Sound Effects", systemImage: "speaker.wave.2.fill", amount: $ledger.waterline.quietSwitchboard.effectsVolume, saveRipple: ledger.saveRipple, previewsSound: true)
                        Toggle("Haptics", isOn: $ledger.waterline.quietSwitchboard.hapticsEnabled).onChange(of: ledger.waterline.quietSwitchboard.hapticsEnabled) { _, _ in ledger.saveRipple() }
                        Toggle("Low Motion Mode", isOn: $ledger.waterline.quietSwitchboard.lowMotionEnabled).onChange(of: ledger.waterline.quietSwitchboard.lowMotionEnabled) { _, _ in ledger.saveRipple() }
                        Text("Sound effects affect taps, skills, and catches. Low Motion freezes pond fish drift while keeping the game playable.")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(PondInk.inkText.opacity(0.72))
                    }
                    .foregroundStyle(PondInk.inkText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tint(PondInk.moss)
                }
            }
        } bottomAccessory: {
            PondButton(title: "Reset Local Save", systemImage: "trash.fill") {
                showReset = true
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
            .padding(.bottom, 8)
            .background(
                LinearGradient(colors: [PondInk.pondDeep.opacity(0.96), PondInk.woodDeep.opacity(0.98)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(edges: .horizontal)
            )
            .overlay(Rectangle().fill(PondInk.gold.opacity(0.24)).frame(height: 1), alignment: .top)
        }
        .confirmationDialog("Reset local save?", isPresented: $showReset, titleVisibility: .visible) {
            Button("Reset", role: .destructive) { ledger.resetPond(); openDock(.start) }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This clears local Lucky Pond progress on this device.")
        }
    }
}
