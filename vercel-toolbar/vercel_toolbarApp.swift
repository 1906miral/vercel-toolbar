//
//  vercel_toolbarApp.swift
//  vercel-toolbar
//
//  Created by Ryan Vogel on 8/20/25.
//

import SwiftUI
import ServiceManagement

@main
struct vercel_toolbarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon and make this a background app
        NSApp.setActivationPolicy(.accessory)
        
        // Create status item with triangle icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            button.image = TriangleIcon().createNSImage(size: CGSize(width: 18, height: 18))
            button.action = #selector(handleClick)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // Create popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(rootView: DeploymentsView())
    }
    
    @objc func handleClick() {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            showContextMenu()
        } else {
            togglePopover()
        }
    }
    
    func showContextMenu() {
        let menu = NSMenu()
        
        // Start at Login
        let startAtLoginItem = NSMenuItem(
            title: isStartAtLoginEnabled() ? "Disable Start at Login" : "Enable Start at Login",
            action: #selector(toggleStartAtLogin),
            keyEquivalent: ""
        )
        startAtLoginItem.target = self
        menu.addItem(startAtLoginItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(
            title: "Quit Vercel Toolbar",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        // Show menu
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }
    
    @objc func toggleStartAtLogin() {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
        
        if isStartAtLoginEnabled() {
            // Disable start at login
            if #available(macOS 13.0, *) {
                try? SMAppService.mainApp.unregister()
                print("✅ Disabled start at login")
            } else {
                SMLoginItemSetEnabled(bundleIdentifier as CFString, false)
                UserDefaults.standard.set(false, forKey: "start_at_login_enabled")
                print("✅ Disabled start at login (legacy)")
            }
        } else {
            // Enable start at login
            if #available(macOS 13.0, *) {
                do {
                    try SMAppService.mainApp.register()
                    print("✅ Enabled start at login")
                } catch {
                    print("❌ Failed to enable start at login: \(error)")
                }
            } else {
                SMLoginItemSetEnabled(bundleIdentifier as CFString, true)
                UserDefaults.standard.set(true, forKey: "start_at_login_enabled")
                print("✅ Enabled start at login (legacy)")
            }
        }
    }
    
    private func isStartAtLoginEnabled() -> Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        } else {
            // For older macOS versions, use UserDefaults as a simple check
            return UserDefaults.standard.bool(forKey: "start_at_login_enabled")
        }
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    private func togglePopover() {
        if popover.isShown {
            popover.performClose(nil)
        } else {
            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}
