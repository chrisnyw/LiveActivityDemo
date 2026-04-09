import SwiftUI

struct SportsScoreDemoView: View {
    @State private var viewModel = SportsScoreDemoViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel
        List {
            Section {
                ScoreboardView(
                    homeTeam: viewModel.homeTeam,
                    awayTeam: viewModel.awayTeam,
                    homeEmoji: viewModel.homeEmoji,
                    awayEmoji: viewModel.awayEmoji,
                    homeScore: viewModel.homeScore,
                    awayScore: viewModel.awayScore,
                    isActive: viewModel.isActive,
                    period: viewModel.period,
                    gameTime: viewModel.gameTime
                )
            }

            if viewModel.isActive {
                Section("Score Controls") {
                    HStack {
                        Button {
                            viewModel.scoreHome(points: 2)
                        } label: {
                            Label("+2 \(viewModel.homeTeam)", systemImage: "plus.circle")
                        }
                        .buttonStyle(.bordered)

                        Button {
                            viewModel.scoreHome(points: 3)
                        } label: {
                            Label("+3", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(.bordered)
                    }

                    HStack {
                        Button {
                            viewModel.scoreAway(points: 2)
                        } label: {
                            Label("+2 \(viewModel.awayTeam)", systemImage: "plus.circle")
                        }
                        .buttonStyle(.bordered)

                        Button {
                            viewModel.scoreAway(points: 3)
                        } label: {
                            Label("+3", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Section("Game Clock") {
                    Stepper("Quarter \(viewModel.period)", value: $viewModel.period, in: 1...4)

                    Button("Advance Clock") {
                        viewModel.advanceClock()
                    }
                }

                Section {
                    Button(role: .destructive) {
                        viewModel.endActivity()
                    } label: {
                        Label("End Game", systemImage: "xmark.circle")
                    }
                }
            } else {
                Section {
                    Button {
                        viewModel.startActivity()
                    } label: {
                        Label("Start Game", systemImage: "play.fill")
                    }
                }
            }
        }
        .navigationTitle("Sports Score")
        .alert("Failed to Start Activity", isPresented: $viewModel.showError) { } message: {
            Text(viewModel.errorMessage)
        }
    }
}
