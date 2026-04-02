import AppKit

class UpdateChecker {
    static let currentVersion = "1.0.0"
    private static let repoURL = "https://api.github.com/repos/HugoRS00/CelebrateShortcut/releases/latest"

    static func checkForUpdates(settingsManager: SettingsManager, silent: Bool = true) {
        guard settingsManager.autoUpdateEnabled || !silent else { return }

        guard let url = URL(string: repoURL) else { return }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 10

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let tagName = json["tag_name"] as? String,
                  let htmlURL = json["html_url"] as? String else {
                if !silent {
                    DispatchQueue.main.async { showUpToDate() }
                }
                return
            }

            let latestVersion = tagName.trimmingCharacters(in: CharacterSet(charactersIn: "vV"))

            if isNewer(latestVersion, than: currentVersion) {
                DispatchQueue.main.async {
                    showUpdateAlert(version: latestVersion, url: htmlURL)
                }
            } else if !silent {
                DispatchQueue.main.async { showUpToDate() }
            }
        }.resume()
    }

    private static func isNewer(_ remote: String, than local: String) -> Bool {
        let r = remote.split(separator: ".").compactMap { Int($0) }
        let l = local.split(separator: ".").compactMap { Int($0) }
        for i in 0..<max(r.count, l.count) {
            let rv = i < r.count ? r[i] : 0
            let lv = i < l.count ? l[i] : 0
            if rv > lv { return true }
            if rv < lv { return false }
        }
        return false
    }

    private static func showUpdateAlert(version: String, url: String) {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = "Update Available"
        alert.informativeText = "Celebrate Shortcut v\(version) is available. You're on v\(currentVersion)."
        alert.addButton(withTitle: "Download")
        alert.addButton(withTitle: "Later")
        alert.alertStyle = .informational

        if alert.runModal() == .alertFirstButtonReturn {
            if let downloadURL = URL(string: url) {
                NSWorkspace.shared.open(downloadURL)
            }
        }
    }

    private static func showUpToDate() {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = "You're up to date!"
        alert.informativeText = "Celebrate Shortcut v\(currentVersion) is the latest version."
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .informational
        alert.runModal()
    }
}
