import Foundation
import Combine

public struct PatchRule: Identifiable, Codable {
    public var id = UUID()
    public var targetBundleId: String
    public var relativePath: String
    public var replacementFileName: String
    
    public init(id: UUID = UUID(), targetBundleId: String, relativePath: String, replacementFileName: String) {
        self.id = id
        self.targetBundleId = targetBundleId
        self.relativePath = relativePath
        self.replacementFileName = replacementFileName
    }
}

public struct PatchProject: Identifiable, Codable {
    public var id: UUID
    public var name: String
    public var author: String
    public var isPrivate: Bool
    public var isApplied: Bool
    public var rules: [PatchRule]
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(id: UUID = UUID(), name: String, author: String = "PAKIN EPIC", isPrivate: Bool = false, isApplied: Bool = false, rules: [PatchRule] = [], createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.author = author
        self.isPrivate = isPrivate
        self.isApplied = isApplied
        self.rules = rules
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public final class PatchProjectStore: ObservableObject {
    @Published public var projects: [PatchProject] = []
    
    public init() {
        loadDefaultProjects()
    }
    
    public func loadDefaultProjects() {
        self.projects = [
            PatchProject(
                name: "MENU 3105 FFM",
                author: "PARKINSHOP",
                isPrivate: false,
                isApplied: false,
                rules: [
                    PatchRule(targetBundleId: "com.dts.freefiremax", relativePath: "Library/Application Support/patch.dat", replacementFileName: "ffm_patch.bin")
                ]
            ),
            PatchProject(
                name: "MENU FFTH NEW BYPASS",
                author: "PARKINSHOP",
                isPrivate: false,
                isApplied: false,
                rules: [
                    PatchRule(targetBundleId: "com.dts.freefireth", relativePath: "Library/Caches/bypass.cfg", replacementFileName: "bypass_th.bin")
                ]
            )
        ]
    }
    
    public func applyPatch(_ project: PatchProject) {
        if let idx = projects.firstIndex(where: { $0.id == project.id }) {
            projects[idx].isApplied = true
            projects[idx].updatedAt = Date()
            AppLog.shared.log("Applied patch: \(project.name)")
        }
    }
    
    public func restorePatch(_ project: PatchProject) {
        if let idx = projects.firstIndex(where: { $0.id == project.id }) {
            projects[idx].isApplied = false
            projects[idx].updatedAt = Date()
            AppLog.shared.log("Restored original files for patch: \(project.name)")
        }
    }
    
    public func deletePatch(_ project: PatchProject) {
        projects.removeAll(where: { $0.id == project.id })
        AppLog.shared.log("Deleted patch project: \(project.name)")
    }
}

public final class PatchDraftCoordinator: ObservableObject {
    @Published public var isDraftPresented: Bool = false
    public init() {}
}

public final class FileOperationCoordinator: ObservableObject {
    @Published public var isOperating: Bool = false
    @Published public var statusMessage: String = ""
    public init() {}
}
