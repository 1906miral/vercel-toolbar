//
//  SettingsView.swift
//  vercel-toolbar
//
//  Created by Ryan Vogel on 8/20/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var vercelService = VercelService.shared
    @State private var vercelToken = ""
    @State private var showingToken = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 12) {
                TriangleIcon()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.blue)
                
                Text("Vercel Toolbar Settings")
                    .font(.geist(.title2, weight: .bold))
            }
            
            Divider()
            
            // Vercel Token Configuration
            VStack(alignment: .leading, spacing: 16) {
                Text("Vercel Configuration")
                    .font(.geist(.headline, weight: .semibold))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Access Token")
                        .font(.geist(.callout, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("Enter your Vercel access token to view deployments")
                        .font(.geist(.caption))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 10) {
                        if showingToken {
                            TextField("Vercel access token", text: $vercelToken)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.geistMono(.caption))
                        } else {
                            SecureField("Vercel access token", text: $vercelToken)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.geistMono(.caption))
                        }
                        
                        Button(action: {
                            showingToken.toggle()
                        }) {
                            Image(systemName: showingToken ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                                .font(.system(size: 12))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .help(showingToken ? "Hide token" : "Show token")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(NSColor.controlBackgroundColor).opacity(0.8))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                }
                
                Button(action: {
                    vercelService.setVercelToken(vercelToken)
                }) {
                    Text("Save Token")
                        .font(.geist(.callout, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(vercelToken.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(vercelToken.isEmpty)
                
                // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    Text("How to get your access token:")
                        .font(.geist(.caption, weight: .semibold))
                    
                    HStack(spacing: 4) {
                        Text("1. Go to")
                            .font(.geist(.caption2))
                            .foregroundColor(.secondary)
                        Button("vercel.com/account/settings/tokens") {
                            if let url = URL(string: "https://vercel.com/account/settings/tokens") {
                                NSWorkspace.shared.open(url)
                            }
                        }
                        .font(.geist(.caption2))
                        .foregroundColor(.blue)
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Text("2. Create a new token")
                        .font(.geist(.caption2))
                        .foregroundColor(.secondary)
                    Text("3. Copy and paste it above")
                        .font(.geist(.caption2))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            // Footer
            Divider()
            
            HStack {
                Spacer()
                Button("Made by Ryan V") {
                    if let url = URL(string: "https://x.com/ryandavogel") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .font(.geist(.caption2))
                .foregroundColor(.secondary)
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    // Change cursor to pointing hand on hover
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
                Spacer()
            }
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        }
        .padding(24)
        .frame(width: 450, height: 500)
        .onAppear {
            vercelToken = UserDefaults.standard.string(forKey: "vercel_token") ?? ""
        }
    }
}

#Preview {
    SettingsView()
}