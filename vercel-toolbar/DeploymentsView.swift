//
//  DeploymentsView.swift
//  vercel-toolbar
//
//  Created by Ryan Vogel on 8/20/25.
//

import SwiftUI

struct DeploymentsView: View {
    @StateObject private var vercelService = VercelService.shared
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    TriangleIcon()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.blue)
                    Text("Vercel Deployments")
                        .font(.geist(.headline, weight: .semibold))
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        vercelService.refreshDeployments()
                    }) {
                        Image(systemName: vercelService.isLoading ? "arrow.clockwise" : "arrow.clockwise")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(vercelService.isLoading ? 360 : 0))
                            .animation(vercelService.isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: vercelService.isLoading)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(vercelService.isLoading)
                    .help("Refresh deployments")
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .help("Settings")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(NSColor.controlBackgroundColor).opacity(0.8))
            
            Divider()
            
            // Content
            if vercelService.isLoading && vercelService.deployments.isEmpty {
                VStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading deployments...")
                        .font(.geist(.caption))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = vercelService.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 32))
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .font(.geist(.caption))
                        .padding(.horizontal)
                    Button("Open Settings") {
                        showingSettings = true
                    }
                    .font(.geist(.caption, weight: .medium))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else if vercelService.deployments.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    Text("No deployments yet")
                        .font(.geist(.caption))
                        .foregroundColor(.secondary)
                    Text("Deploy something to see it appear!")
                        .font(.geist(.caption2))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(vercelService.deployments) { deployment in
                            DeploymentRowView(deployment: deployment)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                }
            }
            
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
        .frame(width: 400, height: 500)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .onAppear {
            vercelService.loadDeployments()
        }
    }
}

struct DeploymentRowView: View {
    let deployment: Deployment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text(deployment.name)
                    .font(.geist(.subheadline, weight: .medium))
                    .lineLimit(1)
                
                Spacer()
                
                DeploymentStatusBadge(state: deployment.state)
            }
            
            if let commitMessage = deployment.commitMessage {
                Text(commitMessage)
                    .font(.geist(.caption))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            if let url = deployment.url, !url.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "link")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(deployment.displayUrl)
                        .font(.geist(.caption2))
                        .foregroundColor(.blue)
                        .lineLimit(1)
                        .onTapGesture {
                            if let deploymentUrl = URL(string: "https://\(deployment.displayUrl)") {
                                NSWorkspace.shared.open(deploymentUrl)
                            }
                        }
                    
                    Spacer()
                }
            }
            
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(deployment.createdDate, style: .relative)
                        .font(.geist(.caption2))
                        .foregroundColor(.secondary)
                }
                
                if let branchName = deployment.branchName {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.branch")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Text(branchName)
                            .font(.geist(.caption2))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                if let target = deployment.target {
                    Text(target.capitalized)
                        .font(.geist(.caption2, weight: .medium))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(4)
                }
            }
        }
        .padding(12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
        )
    }
}

struct DeploymentStatusBadge: View {
    let state: DeploymentState
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(colorForState)
                .frame(width: 6, height: 6)
            Text(state.displayName)
                .font(.geist(.caption2, weight: .medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(colorForState.opacity(0.15))
        .cornerRadius(6)
    }
    
    private var colorForState: Color {
        switch state {
        case .ready:
            return .green
        case .building, .initializing, .queued:
            return .blue
        case .error:
            return .red
        case .canceled, .deleted:
            return .gray
        }
    }
}

#Preview {
    DeploymentsView()
}