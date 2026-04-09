import SwiftUI

struct DeliveryDemoView: View {
    @State private var viewModel = DeliveryDemoViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel
        List {
            Section {
                DeliveryStatusCard(currentStatus: viewModel.currentStatus, isActive: viewModel.isActive)
            }

            if !viewModel.isActive {
                Section("Configuration") {
                    TextField("Courier Name", text: $viewModel.courierName)
                    Stepper("ETA: \(viewModel.estimatedSeconds) sec", value: $viewModel.estimatedSeconds, in: 1...300, step: 5)
                }
            }

            Section {
                if viewModel.isActive {
                    if let next = viewModel.currentStatus.next {
                        Button {
                            viewModel.advanceStatus(to: next)
                        } label: {
                            Label("Advance to: \(next.title)", systemImage: next.icon)
                        }
                    }

                    Button(role: .destructive) {
                        viewModel.endActivity()
                    } label: {
                        Label("End Delivery", systemImage: "xmark.circle")
                    }
                } else {
                    Button {
                        viewModel.startActivity()
                    } label: {
                        Label("Start Delivery", systemImage: "play.fill")
                    }
                }
            }
        }
        .navigationTitle("Delivery Tracker")
        .onDisappear {
            viewModel.cleanup()
        }
        .alert("Failed to Start Activity", isPresented: $viewModel.showError) { } message: {
            Text(viewModel.errorMessage)
        }
    }
}
