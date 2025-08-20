//
//  VercelModels.swift
//  vercel-toolbar
//
//  Created by Ryan Vogel on 8/20/25.
//

import Foundation

struct DeploymentResponse: Codable {
    let deployments: [Deployment]
    let pagination: Pagination
}

struct Deployment: Codable, Identifiable {
    let uid: String
    let name: String
    let projectId: String
    let url: String?
    let created: Int64
    let state: DeploymentState
    let readyState: DeploymentState?
    let readySubstate: String?
    let source: String
    let target: String?
    let creator: Creator?
    let inspectorUrl: String?
    let meta: Meta?
    let aliasAssigned: Int64?
    let isRollbackCandidate: Bool?
    let createdAt: Int64?
    let buildingAt: Int64?
    let ready: Int64?
    
    var id: String { uid }
    
    var createdDate: Date {
        Date(timeIntervalSince1970: TimeInterval(created) / 1000.0)
    }
    
    var displayUrl: String {
        url ?? "Building..."
    }
    
    var commitMessage: String? {
        meta?.githubCommitMessage
    }
    
    var branchName: String? {
        meta?.githubCommitRef
    }
}

struct Creator: Codable {
    let uid: String
    let username: String?
    let email: String?
    let githubLogin: String?
}

struct Meta: Codable {
    let githubCommitAuthorName: String?
    let githubCommitAuthorEmail: String?
    let githubCommitMessage: String?
    let githubCommitRef: String?
    let githubCommitRepo: String?
    let githubCommitSha: String?
    let githubOrg: String?
    let githubRepo: String?
    let branchAlias: String?
}

struct Pagination: Codable {
    let count: Int
    let next: Int64?
    let prev: Int64?
}

enum DeploymentState: String, Codable, CaseIterable {
    case building = "BUILDING"
    case error = "ERROR"
    case initializing = "INITIALIZING"
    case queued = "QUEUED"
    case ready = "READY"
    case canceled = "CANCELED"
    case deleted = "DELETED"
    
    var displayName: String {
        switch self {
        case .building: return "Building"
        case .error: return "Error"
        case .initializing: return "Initializing"
        case .queued: return "Queued"
        case .ready: return "Ready"
        case .canceled: return "Canceled"
        case .deleted: return "Deleted"
        }
    }
    
    var color: String {
        switch self {
        case .ready: return "green"
        case .building, .initializing, .queued: return "orange"
        case .error: return "red"
        case .canceled, .deleted: return "gray"
        }
    }
}