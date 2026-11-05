import SwiftUI

@main
public struct PAKIN_EPICApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var patchDraftCoordinator = PatchDraftCoordinator()
    @StateObject private var fileOperationCoordinator = FileOperationCoordinator()
    @StateObject private var patchStore = PatchProjectStore()
    @StateObject private var repositoryStore = PackageRepositoryStore()
    @StateObject private var licenseManager = HTVLicenseManager()
    
    // Stealth Clock Camouflage State
    @State private var isStealthUnlocked: Bool = false
    
    @State private var showOnboarding: Bool = false
    @State private var showUpdateAlert: Bool = false
    @State private var updateMessage: String = ""
    
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            ZStack {
                if !isStealthUnlocked {
                    // 100% Native iOS Clock Camouflage Interface
                    ClockRootView(onSecretUnlocked: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            isStealthUnlocked = true
                        }
                    })
                    .transition(.opacity)
                } else {
                    // Unlocked Real System: License Gate or Full Feature Dashboard
                    if !licenseManager.isAuthorized {
                        HTVLicenseGateView()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        ContentView()
                            .transition(.opacity)
                    }
                }
            }
            .environmentObject(appState)
            .environmentObject(patchDraftCoordinator)
            .environmentObject(fileOperationCoordinator)
            .environmentObject(patchStore)
            .environmentObject(repositoryStore)
            .environmentObject(licenseManager)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    await licenseManager.bootstrap()
                }
            }
            .onOpenURL { url in
                handleIncomingURL(url)
            }
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        AppLog.shared.log("Received URL: \(url.absoluteString)")
        if url.scheme == AppConfig.urlScheme {
            withAnimation {
                isStealthUnlocked = true
            }
            AppLog.shared.log("Importing patch package via URL scheme...")
        }
    }
}
