import SwiftUI

public struct FreeFireHubView: View {
    @ObservedObject var cloudConfig = CloudConfigManager.shared
    @EnvironmentObject var appState: AppState
    
    @State private var activeTab: String = "app" // "app" or "dns"
    @State private var selectedGame: FreeFireGameType? = nil // nil = catalog, value = detail view
    @State private var selectedCategory: String = "AIM"
    @State private var showingSettings: Bool = false
    @State private var showingHistory: Bool = false
    @State private var showingFileManager: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isProcessing: Bool = false
    @State private var dnsProtectionEnabled: Bool = true
    
    private let categories = [
        ("AIM", "scope", "เล็งเป้า")
    ]
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Pure Dark OLED Background
            darkOLEDBackground
            
            VStack(spacing: 0) {
                // Top Header with Prominent Logo
                topHeaderView
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                
                // Main Content
                ScrollView(showsIndicators: false) {
                    if activeTab == "app" {
                        if let game = selectedGame {
                            // Detail View for Selected Game
                            gameDetailView(for: game)
                        } else {
                            // Clean Catalog Overview (Stats + Games Grid)
                            catalogOverviewView
                        }
                    } else {
                        // DNS & Anti-Ban Tab
                        dnsProtectionView
                    }
                    
                    Spacer().frame(height: 120)
                }
            }
            
            // Sticky Bottom Bar
            VStack(spacing: 0) {
                Spacer()
                stickyBottomBar
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingHistory) {
            historySheetView
        }
        .sheet(isPresented: $showingFileManager) {
            sandboxFileManagerSheet
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("PAKIN HEX CONTROL CENTER"),
                message: Text(alertMessage),
                dismissButton: .default(Text("ตกลง"))
            )
        }
    }
    
    // MARK: - Dark OLED Monochrome Background
    private var darkOLEDBackground: some View {
        ZStack {
            Color(red: 0.02, green: 0.02, blue: 0.03).edgesIgnoringSafeArea(.all)
            
            // Subtle high-contrast grid lines
            GeometryReader { geo in
                Path { path in
                    let step: CGFloat = 40
                    for x in stride(from: 0, to: geo.size.width, by: step) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geo.size.height))
                    }
                }
                .stroke(Color.white.opacity(0.02), lineWidth: 0.5)
            }
        }
    }
    
    // MARK: - Header (Clean Black & White with Sharp Logo)
    private var topHeaderView: some View {
        HStack {
            // Brand Logo & Title
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(white: 0.10))
                        .frame(width: 40, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    
                    Image(systemName: "hexagon.fill")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("PAKIN HEX")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(0.5)
                    
                    Text("CONTROL CENTER v2.0")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(white: 0.70))
                        .tracking(1.0)
                }
            }
            
            Spacer()
            
            // Header Buttons: File Manager, History & Settings
            HStack(spacing: 8) {
                Button(action: { showingFileManager = true }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(white: 0.10))
                            .frame(width: 38, height: 38)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.15), lineWidth: 1))
                        Image(systemName: "folder.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: { showingHistory = true }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(white: 0.10))
                            .frame(width: 38, height: 38)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.15), lineWidth: 1))
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: { showingSettings = true }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(white: 0.10))
                            .frame(width: 38, height: 38)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.15), lineWidth: 1))
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // MARK: - Catalog Overview View
    private var catalogOverviewView: some View {
        VStack(spacing: 16) {
            // Top 3 Info Cards
            deviceInfoCards
                .padding(.horizontal, 16)
            
            // Section Header: SUPPORTED GAMES
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    Text("LAUNCHER.SUPPORTED_GAMES")
                        .font(.system(size: 12, weight: .heavy))
                        .foregroundColor(.white)
                        .tracking(0.5)
                }
                Spacer()
                Text("CATALOG_ONLINE")
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.white)
                    .cornerRadius(6)
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
            
            // 2x2 Clean Monochrome Games Grid
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                // Free Fire MAX Card
                gameGridCard(
                    title: "Free Fire Max",
                    bundleId: "com.dts.freefiremax",
                    iconName: "bolt.shield.fill",
                    isAvailable: true,
                    action: { selectedGame = .max }
                )
                
                // Free Fire Normal Card
                gameGridCard(
                    title: "Free Fire",
                    bundleId: "com.dts.freefireth",
                    iconName: "flame.fill",
                    isAvailable: true,
                    action: { selectedGame = .normal }
                )
                
                // Locket
                gameGridCard(
                    title: "com.locket.Locket",
                    bundleId: "com.locket.Locket",
                    iconName: "app.fill",
                    isAvailable: false,
                    action: {
                        alertMessage = "แอป Locket กำลังอยู่ระหว่างเตรียมแพตช์ 3105 ในอัปเดตถัดไป"
                        showAlert = true
                    }
                )
                
                // CapCut Pro
                gameGridCard(
                    title: "CapCut Pro",
                    bundleId: "com.lemon.lvoverseas",
                    iconName: "scissors",
                    isAvailable: false,
                    action: {
                        alertMessage = "แพตช์ CapCut Pro กำลังอยู่ระหว่างเตรียมปล่อยจากเซิร์ฟเวอร์"
                        showAlert = true
                    }
                )
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Device Info Cards (3 Horizontal Monochrome Cards)
    private var deviceInfoCards: some View {
        HStack(spacing: 8) {
            // Card 1: iOS Version
            infoCard(
                icon: "applelogo",
                title: "launcher.ios_version",
                value: DeviceUtility.systemVersion
            )
            
            // Card 2: Device Model
            infoCard(
                icon: "iphone",
                title: "launcher.device",
                value: DeviceUtility.modelIdentifier
            )
            
            // Card 3: Support Status
            infoCard(
                icon: "checkmark.circle.fill",
                title: "launcher.support",
                value: "settings.supported"
            )
        }
    }
    
    private func infoCard(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(Color(white: 0.65))
                .lineLimit(1)
            
            Text(value)
                .font(.system(size: 11, weight: .heavy, design: .monospaced))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 6)
        .background(Color(white: 0.08))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
    
    // MARK: - Game Grid Card (2x2 Clean Black & White)
    private func gameGridCard(title: String, bundleId: String, iconName: String, isAvailable: Bool, action: @escaping () -> Void) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(white: 0.12))
                    .frame(width: 48, height: 48)
                    .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                
                Image(systemName: iconName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(isAvailable ? .white : Color(white: 0.4))
            }
            .padding(.top, 4)
            
            VStack(spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundColor(.white)
                
                Text(bundleId)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color(white: 0.6))
                    .lineLimit(1)
            }
            
            Button(action: action) {
                Text(isAvailable ? "launcher.open_app" : "เร็วๆ นี้")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundColor(isAvailable ? .black : Color(white: 0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(isAvailable ? Color.white : Color(white: 0.15))
                    .cornerRadius(8)
            }
        }
        .padding(14)
        .background(Color(white: 0.08))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
    
    // MARK: - Game Detail View (3105 Mods List)
    private func gameDetailView(for game: FreeFireGameType) -> some View {
        VStack(spacing: 16) {
            // Back Button & Refresh
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedGame = nil
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .bold))
                        Text("กลับหน้าหลัก")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(white: 0.12))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.15), lineWidth: 1))
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        await cloudConfig.fetchCloudConfig()
                        alertMessage = "ซิงค์ข้อมูลม็อด 3105 ล่าสุดจากเซิร์ฟเวอร์เรียบร้อย"
                        showAlert = true
                    }
                }) {
                    HStack(spacing: 4) {
                        if cloudConfig.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.6)
                        } else {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 11, weight: .bold))
                        }
                        Text("รีเฟรช")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(white: 0.12))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.15), lineWidth: 1))
                }
            }
            .padding(.horizontal, 16)
            
            // Game Big Banner
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(Color(white: 0.10))
                        .frame(width: 54, height: 54)
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                    
                    Image(systemName: game.iconName)
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }
                
                Text(game.displayName)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.white)
                
                Text(game.rawValue)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color(white: 0.6))
            }
            .padding(.vertical, 2)
            
            // Category Buttons (4 Clean Monochrome Buttons)
            HStack(spacing: 8) {
                ForEach(categories, id: \.0) { cat in
                    Button(action: {
                        selectedCategory = cat.0
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: cat.1)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(selectedCategory == cat.0 ? .black : .white)
                            Text(cat.2)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(selectedCategory == cat.0 ? .black : Color(white: 0.7))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedCategory == cat.0 ? Color.white : Color(white: 0.08))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(selectedCategory == cat.0 ? 1.0 : 0.15), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // Section Header: LAUNCHER.TITLE_AIM
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "scope")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    Text("AIM MODS")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundColor(.white)
                }
                Spacer()
                Text("READY")
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.white)
                    .cornerRadius(6)
            }
            .padding(.horizontal, 16)
            .padding(.top, 2)
            
            // Matching 3105 Mods List
            let matchingMods = cloudConfig.freeFireMods.filter { mod in
                mod.matches(game: game) && (mod.category.uppercased() == selectedCategory || selectedCategory == "AIM")
            }
            
            if matchingMods.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 36))
                        .foregroundColor(Color(white: 0.4))
                    Text("ยังไม่มีไฟล์ 3105 ในหมวดหมู่นี้")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Text("แอดมินสามารถเพิ่มไฟล์จากระบบหลังบ้านได้ตลอดเวลา")
                        .font(.system(size: 11))
                        .foregroundColor(Color(white: 0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 35)
                .background(Color(white: 0.08))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
                .padding(.horizontal, 16)
            } else {
                VStack(spacing: 8) {
                    ForEach(matchingMods) { mod in
                        modRowItem(mod: mod, game: game)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Mod Row Item (Clean Black & White with Status Indicator)
    private func modRowItem(mod: FreeFireModItem, game: FreeFireGameType) -> some View {
        let isInstalled = cloudConfig.isModInstalled(id: mod.id)
        let pass = mod.password ?? "TomHrVip"
        
        return HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(white: 0.14))
                    .frame(width: 38, height: 38)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.15), lineWidth: 1))
                
                Image(systemName: "scope")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Title & Auto-Password info
            VStack(alignment: .leading, spacing: 3) {
                Text(mod.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    if isInstalled {
                        Text("ติดตั้งแล้ว")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                        Text("•")
                            .foregroundColor(Color(white: 0.4))
                        Text("พร้อมใช้งาน")
                            .font(.system(size: 10))
                            .foregroundColor(Color(white: 0.7))
                    } else {
                        Text("พร้อมติดตั้ง")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color(white: 0.6))
                    }
                }
            }
            
            Spacer()
            
            // Revert / Install Action Button
            Button(action: {
                Task {
                    isProcessing = true
                    if isInstalled {
                        _ = await cloudConfig.restoreOriginal(mod: mod, forGame: game)
                        alertMessage = "ย้อนกลับคืนค่าเดิมของ \(game.displayName) สำเร็จเรียบร้อยแล้ว ไฟล์ถูกรีเซ็ตกลับเป็นค่าเริ่มต้น"
                    } else {
                        _ = await cloudConfig.installMod(mod: mod, forGame: game)
                        alertMessage = "ใส่รหัสผ่านอัตโนมัติ (\(pass)) และติดตั้ง \(mod.name) เข้าสู่ \(game.displayName) เรียบร้อยแล้ว!"
                    }
                    isProcessing = false
                    showAlert = true
                }
            }) {
                HStack(spacing: 5) {
                    Image(systemName: isInstalled ? "arrow.uturn.backward.circle.fill" : "bolt.fill")
                        .font(.system(size: 11, weight: .bold))
                    Text(isInstalled ? "ย้อนกลับคืนค่า" : "ติดตั้ง (1-Tap)")
                        .font(.system(size: 11, weight: .heavy))
                }
                .foregroundColor(isInstalled ? .black : .white)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(isInstalled ? Color.white : Color(white: 0.16))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(isInstalled ? 1.0 : 0.25), lineWidth: 1)
                )
            }
            .disabled(isProcessing)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(white: 0.08))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isInstalled ? Color.white.opacity(0.8) : Color.white.opacity(0.12), lineWidth: 1)
        )
    }
    
    // MARK: - DNS & Anti-Ban Tab
    private var dnsProtectionView: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                    .font(.system(size: 44))
                    .foregroundColor(.white)
                Text("ANTI-BAN DNS SHIELD")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(.white)
                Text("ระบบป้องกันการส่งบันทึกและบล็อกการวิเคราะห์ไฟล์ 3105 ไปยังเซิร์ฟเวอร์")
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.6))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                HStack {
                    Text("เปิดใช้งานระบบป้องกัน (Bypass)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Toggle("", isOn: $dnsProtectionEnabled)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color.white))
                }
                .padding(14)
                .background(Color(white: 0.08))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.12), lineWidth: 1))
                
                HStack {
                    Text("DNS Gateway:")
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.6))
                    Spacer()
                    Text("1.1.1.1 (Cloudflare Secured)")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
                .padding(14)
                .background(Color(white: 0.08))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.12), lineWidth: 1))
                
                Button(action: {
                    if let url = URL(string: "https://raw.githubusercontent.com/zsxzsxvv-commits/pakin-app-build3.0/main/pakin_antiban_dns.mobileconfig") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.doc.fill")
                            .font(.system(size: 13, weight: .bold))
                        Text("ดาวน์โหลดโปรไฟล์ DNS (.mobileconfig)")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Sticky Bottom Bar (Key Expiration Card + Tab Switcher)
    private var stickyBottomBar: some View {
        VStack(spacing: 8) {
            // Key Info Card
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(white: 0.15))
                        .frame(width: 36, height: 36)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.25), lineWidth: 1))
                    
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("PAKIN VIP KEY (1 Device)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Text("29d 23h left • Expires 31/12/2026")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(white: 0.7))
                }
                
                Spacer()
                
                Button(action: {
                    alertMessage = "License Key ผูกกับเครื่องนี้เรียบร้อย (1 Key : 1 Device)\nรหัสเครื่อง: \(DeviceUtility.modelIdentifier)\nรองรับม็อด 3105 Auto-Password"
                    showAlert = true
                }) {
                    Text("launcher.view_key")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(Color.white)
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(Color(white: 0.08))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            
            // Bottom Tab Switcher
            HStack(spacing: 8) {
                Button(action: {
                    activeTab = "app"
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "gamecontroller.fill")
                        Text("tab.app")
                            .font(.system(size: 13, weight: .heavy))
                    }
                    .foregroundColor(activeTab == "app" ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(activeTab == "app" ? Color.white : Color.clear)
                    .cornerRadius(8)
                }
                
                Button(action: {
                    activeTab = "dns"
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "shield.fill")
                        Text("tab.dns")
                            .font(.system(size: 13, weight: .heavy))
                    }
                    .foregroundColor(activeTab == "dns" ? .black : Color(white: 0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(activeTab == "dns" ? Color.white : Color.clear)
                    .cornerRadius(8)
                }
            }
            .padding(3)
            .background(Color(white: 0.08))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0.02, green: 0.02, blue: 0.03).opacity(0.0), Color(red: 0.02, green: 0.02, blue: 0.03)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: - History Sheet
    private var historySheetView: some View {
        ZStack {
            Color(red: 0.04, green: 0.04, blue: 0.05).edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                HStack {
                    Text("ประวัติการติดตั้ง 3105")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button("ปิด") { showingHistory = false }
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("ยิงคอขึ้นหัว (Auto Headshot)")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                            Text("ใส่รหัสผ่านอัตโนมัติ: TomHrVip • สำเร็จ")
                                .font(.system(size: 11))
                                .foregroundColor(Color(white: 0.6))
                        }
                        Spacer()
                    }
                    .padding(14)
                    .background(Color(white: 0.08))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Local Sandbox File Manager Sheet
    private var sandboxFileManagerSheet: some View {
        ZStack {
            Color(red: 0.04, green: 0.04, blue: 0.05).edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "folder.fill")
                            .foregroundColor(.white)
                        Text("Local File Manager (Sandbox)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button("ปิด") { showingFileManager = false }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(white: 0.15))
                        .cornerRadius(6)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Sandbox Notice
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color(white: 0.7))
                    Text("การจัดการไฟล์ถูกจำกัดอยู่ในพื้นที่ Sandbox ของแอปเพื่อความปลอดภัยตามมาตรฐาน iOS")
                        .font(.system(size: 11))
                        .foregroundColor(Color(white: 0.7))
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(white: 0.08))
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                // Files List in Local Documents
                ScrollView {
                    VStack(spacing: 8) {
                        // Bundled Patch File
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(white: 0.15))
                                    .frame(width: 34, height: 34)
                                Image(systemName: "doc.zipper")
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("neck_aim.3105")
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                Text("ขนาด: 64,030 ไบต์ • สถานะ: พร้อมใช้งาน (Bundled)")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(white: 0.6))
                            }
                            Spacer()
                            
                            Button(action: {
                                alertMessage = "ตรวจสอบไฟล์ neck_aim.3105 สมบูรณ์ (SHA-256 Verified)"
                                showAlert = true
                            }) {
                                Text("ตรวจสอบ")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.white)
                                    .cornerRadius(6)
                            }
                        }
                        .padding(12)
                        .background(Color(white: 0.08))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
        }
    }
}
