import SwiftUI

struct WorkoutTimerDemoView: View {
    @State private var viewModel = WorkoutTimerDemoViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel
        List {
            Section {
                WorkoutCard(
                    selectedType: viewModel.selectedType,
                    isActive: viewModel.isActive,
                    formattedTime: viewModel.formattedTime,
                    heartRate: viewModel.heartRate,
                    calories: viewModel.calories,
                    distance: viewModel.distance
                )
            }

            if !viewModel.isActive {
                Section("Workout Type") {
                    Picker("Type", selection: $viewModel.selectedType) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            Label(type.title, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }

            Section {
                if viewModel.isActive {
                    Button(role: .destructive) {
                        viewModel.endWorkout()
                    } label: {
                        Label("End Workout", systemImage: "stop.fill")
                    }
                } else {
                    Button {
                        viewModel.startWorkout()
                    } label: {
                        Label("Start Workout", systemImage: "play.fill")
                    }
                }
            }
        }
        .navigationTitle("Workout Timer")
        .alert("Failed to Start Activity", isPresented: $viewModel.showError) { } message: {
            Text(viewModel.errorMessage)
        }
    }
}
