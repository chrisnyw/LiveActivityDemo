# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LiveActivityDemo is a SwiftUI iOS app showcasing 3 Live Activity (ActivityKit) demos. The app demonstrates Dynamic Island and Lock Screen Live Activity presentations for different real-world use cases. No external dependencies — pure Apple frameworks only.

## Build & Test Commands

**Note:** Xcode is installed as `/Applications/Xcode26.4.app` — all `xcodebuild` commands must set `DEVELOPER_DIR` accordingly.

```bash
# Build (requires Xcode 26.4)
DEVELOPER_DIR=/Applications/Xcode26.4.app/Contents/Developer xcodebuild -project LiveActivityDemo.xcodeproj -scheme LiveActivityDemo -sdk iphonesimulator build

# Run all unit tests (Swift Testing framework)
DEVELOPER_DIR=/Applications/Xcode26.4.app/Contents/Developer xcodebuild -project LiveActivityDemo.xcodeproj -scheme LiveActivityDemo -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:LiveActivityDemoTests test

# Run UI tests
DEVELOPER_DIR=/Applications/Xcode26.4.app/Contents/Developer xcodebuild -project LiveActivityDemo.xcodeproj -scheme LiveActivityDemo -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:LiveActivityDemoUITests test
```

## Architecture

### Pattern: Lightweight MVVM

- **Models** (`Models/`): `DemoType` enum (3 cases: delivery, sportsGame, workout)
- **Views** (`Views/`): Demo views that manage their own Live Activity lifecycle via `@State`
- **Shared** (`Shared/`): `ActivityAttributes` definitions compiled into both app and widget extension targets

### Targets

| Target | Description |
|--------|-------------|
| `LiveActivityDemo` | Main iOS app (iOS 17.0+) |
| `LiveActivityDemoWidgetExtension` | Widget extension with Live Activity UIs |
| `LiveActivityDemoTests` | Unit tests (Swift Testing) |
| `LiveActivityDemoUITests` | UI tests (XCTest/XCUIAutomation) |

### Data Flow

```
App (Demo Views) → ActivityKit API (request/update/end)
                         ↓
             Widget Extension (ActivityConfiguration renders UI)
```

- **App Group**: `group.com.chris.LiveActivityDemo`
- **Info.plist**: `NSSupportsLiveActivities = YES` (via build settings)

### Live Activity Demos (3 total)

| Demo | Attributes | Description |
|------|-----------|-------------|
| Delivery Tracker | `DeliveryAttributes` | Food delivery with 4-stage progress (preparing → picked up → on the way → delivered) |
| Sports Score | `SportsGameAttributes` | Live basketball game with score updates, quarters, and game clock |
| Workout Timer | `WorkoutAttributes` | Active workout with real-time heart rate, calories, and distance |

Each demo provides:
- **Lock Screen / Banner**: Full-width presentation with detailed stats
- **Dynamic Island Expanded**: Rich multi-region layout
- **Dynamic Island Compact**: Leading + trailing summary
- **Dynamic Island Minimal**: Single icon/value

### Key Conventions

- `ActivityAttributes` structs live in `Shared/` and compile into both targets
- Live Activity widget files contain the `ActivityConfiguration` + all presentation views
- `MARK:` comments for logical section separation
- Enum cases: `camelCase`; types: `PascalCase`
- Unit tests use **Swift Testing** (`import Testing`, `@Test` macro)
- UI tests use **XCTest/XCUIAutomation**
