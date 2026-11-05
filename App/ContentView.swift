import SwiftUI

public struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    public init() {}
    
    public var body: some View {
        // Direct launcher interface matching RLZXTEAM / PAKIN CONTROL CENTER
        FreeFireHubView()
    }
}
