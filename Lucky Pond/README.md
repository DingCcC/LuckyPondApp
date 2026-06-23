# Lucky Pond

Lucky Pond is a pure offline iOS portrait game built with SwiftUI and SpriteKit.

## Implemented

- Start screen, Home Lobby, Gameplay, Catch Result, Fish Ledger, Pond Decoration, Rods & Charms, Lotus Festival, Achievements, Pond Supplies, and Settings
- SpriteKit pond playfield with swimming emblem fish, ripples, and catch feedback
- Fishing loop: Cast -> Catch Fish -> Fill 3-emblem Catch Reel -> Resolve Combination -> Earn Rewards
- Local JSON save for resources, energy, fish ledger, gear, decor, event progress, achievements, settings, ATT flow status, and first-run state
- Local economy with Coins, Pearls, Energy, Harmony, materials, bait, and Lantern Tokens
- Offline-only Pond Supplies exchange with no ads, no paid shop, no subscriptions, and no purchase wording
- Interactive Pond Guide tutorial from Home -> Gameplay -> Catch Reel -> Reward -> Build/Gear
- Daily Local Quests, long-term Achievements, Lotus Festival missions, and milestone rewards
- Rods, Lines, Floats, and Charms tabs with local upgrade paths
- Hand-painted art catalog: 4 pond backgrounds, 12 Lucky Pond crests, 18 fish portraits, 72 transparent fish pose sprites, 14 decor cards, handcrafted UI atlas crops, 2 UI textures, and app icon variants
- Native App Tracking Transparency request flow with English pre-permission explanation
- Portrait-only configuration, app icon assets, and app version `1.0.0`

## Build

Open `Lucky Pond.xcodeproj` in Xcode and run the `Lucky Pond` scheme on an iPhone simulator or device.

The game stores local progress in the app container under Application Support. Use Settings -> Reset Local Save to clear progress.
