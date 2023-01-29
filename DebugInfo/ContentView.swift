//
//  ContentView.swift
//  DebugInfo
//
//  Created by Venti on 29/01/2023.
//

import SwiftUI
import UIKit

extension CGRect {
    var description: String {
        return "x: \(self.origin.x), y: \(self.origin.y), width: \(self.size.width), height: \(self.size.height)"
    }
}

extension UIEdgeInsets
{
    var description: String {
        return "top: \(self.top), left: \(self.left), bottom: \(self.bottom), right: \(self.right)"
    }
}

struct ContentView: View {
    @StateObject var updaterViewModel = UpdaterViewModel()
    @State var isPaused = false
    
    var body: some View {
        // Allign to the left side
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(updaterViewModel.index)")
                    // Date and time info
                    Group {
                        Text("Date: \(updaterViewModel.now.description)")
                        Text("Time: \(updaterViewModel.now.timeIntervalSince1970)")
                        Text("Readable Time: \(DateFormatter.localizedString(from: updaterViewModel.now, dateStyle: .medium, timeStyle: .medium))")
                        Text("TimeZone: \(TimeZone.current.description)")
                    }
                    
                    // Dump every single possible info on UIScreen
                    Group {
                        Text("Screen: \(UIScreen.main.debugDescription)")
                        Text("UIScreen.main.bounds: \(UIScreen.main.bounds.description)")
                        Text("UIScreen.main.frame: \(UIScreen.main.applicationFrame.description)")
                        Text("UIScreen.main.nativeBounds: \(UIScreen.main.nativeBounds.description)")
                        Text("UIScreen.main.nativeScale: \(UIScreen.main.nativeScale)")
                        Text("UIScreen.main.scale: \(UIScreen.main.scale)")
                    }
                    
                    // Dump every single possible info on UIDevice
                    Group {
                        Text("UIDevice.current.name: \(UIDevice.current.name)")
                        Text("UIDevice.current.model: \(UIDevice.current.model)")
                        Text("UIDevice.current.systemName: \(UIDevice.current.systemName)")
                        Text("UIDevice.current.systemVersion: \(UIDevice.current.systemVersion)")
                        Text("UIDevice.current.orientation: \(UIDevice.current.orientation.rawValue)")
                    }
                    
                    // Dump every single possible info on the main application window
                    Group {
                        Text("UIApplication.shared.windows: \(UIApplication.shared.windows.description)")
                        Text("UIApplication.shared.windows.first?.frame: \(UIApplication.shared.windows.first?.frame.description ?? "nil")")
                    }
                    
                    // Environment info
                    Group {
                        Text("Environment: \(ProcessInfo.processInfo.environment.description)")
                        Text("ProcessInfo.processInfo.arguments: \(ProcessInfo.processInfo.arguments.description)")
                        Text("ProcessInfo.processInfo.environment: \(ProcessInfo.processInfo.environment.description)")
                        Text("ProcessInfo.processInfo.globallyUniqueString: \(ProcessInfo.processInfo.globallyUniqueString)")
                        Text("ProcessInfo.processInfo.hostName: \(ProcessInfo.processInfo.hostName)")
                        Text("ProcessInfo.processInfo.operatingSystemVersionString: \(ProcessInfo.processInfo.operatingSystemVersionString)")
                        Text("ProcessInfo.processInfo.processIdentifier: \(ProcessInfo.processInfo.processIdentifier)")
                        Text("ProcessInfo.processInfo.processName: \(ProcessInfo.processInfo.processName)")
                        Text("ProcessInfo.processInfo.systemUptime: \(ProcessInfo.processInfo.systemUptime)")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            Spacer()
            HStack {
                Spacer()
                // Button to pause and resume the timer to stop the view from refreshing
                Button(action: {
                    if updaterViewModel.timer?.isValid ?? false {
                        updaterViewModel.timer?.invalidate()
                        isPaused = true
                    } else {
                        updaterViewModel.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                            updaterViewModel.refresh()
                        })
                        isPaused = false
                    }
                }, label: {
                    Text(isPaused ? "Resume" : "Pause")
                })
                .buttonStyle(.bordered)
                Spacer()
                // Button to refresh the view manually
                Button(action: {
                    updaterViewModel.refresh()
                }, label: {
                    Text("Refresh")
                })
                .buttonStyle(.bordered)
                Spacer()
                // Button to screenshot the current view
                Button(action: {
                    let window = UIApplication.shared.windows.first
                    let renderer = UIGraphicsImageRenderer(size: window?.frame.size ?? .zero)
                    let image = renderer.image { ctx in
                        window?.drawHierarchy(in: window?.bounds ?? .zero, afterScreenUpdates: true)
                    }
                    // Trigger the Share Sheet
                    let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                }, label: {
                    Text("Screenshot")
                })
                .buttonStyle(.bordered)
                Spacer()
            }
        }
        .padding(.all)
    }
}

class UpdaterViewModel: ObservableObject {
    @Published var index: Int = 0
    @Published var now: Date = Date()

    var timer: Timer?
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.refresh()
        })
    }
    deinit {
        timer?.invalidate()
    }
    func refresh() {
        index += 1
        now = Date()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
