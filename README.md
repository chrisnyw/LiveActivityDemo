# LiveActivityDemo

A SwiftUI sample app demonstrating iOS Live Activities with Dynamic Island and Lock Screen presentations using ActivityKit.

## Features

### 1. Delivery Tracker
Track a food delivery through 4 stages: Preparing, Picked Up, On the Way, and Delivered. Features a progress bar, courier info, and ETA countdown in both Dynamic Island and Lock Screen presentations.

### 2. Sports Score
Follow a live basketball game with real-time score updates. Supports +2 and +3 point scoring for each team, quarter progression, and game clock. The Dynamic Island shows team emojis and scores at a glance.

### 3. Workout Timer
Monitor an active workout session with simulated real-time stats: elapsed time, heart rate, calories burned, and distance. Supports running, cycling, and swimming workout types with automatic updates every 5 seconds.

## Live Activity Presentations

Each demo provides four presentation modes:

| Mode | Description |
|------|-------------|
| **Lock Screen / Banner** | Full-width presentation with detailed stats |
| **Dynamic Island Expanded** | Rich multi-region layout (tap to expand) |
| **Dynamic Island Compact** | Leading + trailing summary (always visible) |
| **Dynamic Island Minimal** | Single icon when sharing with another activity |

## Architecture

| Layer | Description |
|-------|-------------|
| **Models** | `DemoType` enum for navigation |
| **Views** | Demo views managing Live Activity lifecycle via `@State` |
| **Shared** | `ActivityAttributes` definitions (compiled into both targets) |
| **Widget Extension** | `ActivityConfiguration` with Dynamic Island + Lock Screen UIs |

### Data Flow

```
App (Demo Views)
  --> ActivityKit API (request / update / end)
    --> Widget Extension (ActivityConfiguration renders UI)
```

## Key Technologies

- **ActivityKit** — Live Activity lifecycle management
- **WidgetKit** — `ActivityConfiguration` for rendering Live Activity UIs
- **SwiftUI** — All UI built with SwiftUI
- **Dynamic Island** — Compact, expanded, and minimal presentations

## Requirements

- iOS 17.0+
- Xcode 16+
- Swift 6

## Build & Test

```bash
# Build
xcodebuild -project LiveActivityDemo.xcodeproj -scheme LiveActivityDemo -sdk iphonesimulator build

# Run unit tests
xcodebuild -project LiveActivityDemo.xcodeproj -scheme LiveActivityDemo -sdk iphonesimulator test
```

## Project Structure

```
LiveActivityDemo/
  LiveActivityDemoApp.swift       # App entry point
  ContentView.swift               # Navigation to 3 demos
  Models/DemoType.swift           # Demo type enum
  Views/
    DeliveryDemoView.swift        # Delivery tracker controls
    SportsScoreDemoView.swift     # Sports score controls
    WorkoutTimerDemoView.swift    # Workout timer controls
  Shared/
    DeliveryAttributes.swift      # Delivery Live Activity attributes
    SportsGameAttributes.swift    # Sports game Live Activity attributes
    WorkoutAttributes.swift       # Workout Live Activity attributes

LiveActivityDemoWidget/
  LiveActivityDemoWidgetBundle.swift  # Widget bundle entry point
  LiveActivities/
    DeliveryLiveActivity.swift        # Delivery Dynamic Island + Lock Screen
    SportsGameLiveActivity.swift      # Sports Dynamic Island + Lock Screen
    WorkoutLiveActivity.swift         # Workout Dynamic Island + Lock Screen
```
