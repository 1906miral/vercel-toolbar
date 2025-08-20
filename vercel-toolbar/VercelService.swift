//
//  VercelService.swift  
//  vercel-toolbar
//
//  Created by Ryan Vogel on 8/20/25.
//

import Foundation
import Combine

class VercelService: ObservableObject {
    static let shared = VercelService()
    
    @Published var deployments: [Deployment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    private var vercelToken: String? {
        UserDefaults.standard.string(forKey: "vercel_token")
    }
    
    private init() {
        print("🔧 VercelService initialized")
        loadCachedData()
    }
    
    func setVercelToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "vercel_token")
        print("✅ Vercel token saved")
    }
    
    func loadDeployments() {
        print("📋 Loading deployments...")
        
        guard let token = vercelToken, !token.isEmpty else {
            print("❌ No Vercel token found")
            errorMessage = "Vercel token required. Please configure in Settings."
            return
        }
        
        // Show cached data immediately
        loadCachedData()
        
        // Then fetch fresh data
        fetchDeployments()
        
        // Start polling for updates every 30 seconds
        startPolling()
    }
    
    func refreshDeployments() {
        guard vercelToken != nil else {
            errorMessage = "Vercel token required. Please configure in Settings."
            return
        }
        
        fetchDeployments()
    }
    
    private func fetchDeployments() {
        guard let token = vercelToken else { return }
        
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://api.vercel.com/v6/deployments?limit=20") else {
            print("❌ Invalid URL")
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("🌐 Fetching deployments from Vercel API...")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: DeploymentResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        print("❌ API Error: \(error)")
                        self?.errorMessage = "Failed to fetch deployments: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] response in
                    print("📨 Received \(response.deployments.count) deployments")
                    self?.updateDeployments(response.deployments)
                }
            )
            .store(in: &cancellables)
    }
    
    private func startPolling() {
        stopPolling()
        
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            print("⏰ Polling for deployment updates...")
            self?.fetchDeployments()
        }
        
        print("⏰ Started polling every 30 seconds")
    }
    
    private func stopPolling() {
        timer?.invalidate()
        timer = nil
        print("⏹️ Stopped polling")
    }
    
    private func updateDeployments(_ newDeployments: [Deployment]) {
        deployments = newDeployments
        saveToCache(newDeployments)
        errorMessage = nil
        print("✅ Updated \(newDeployments.count) deployments")
    }
    
    private func saveToCache(_ deployments: [Deployment]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(deployments) {
            UserDefaults.standard.set(encoded, forKey: "cached_deployments")
            UserDefaults.standard.set(Date(), forKey: "cached_deployments_timestamp")
            print("💾 Cached \(deployments.count) deployments")
        }
    }
    
    private func loadCachedData() {
        print("💾 Loading cached data...")
        guard let data = UserDefaults.standard.data(forKey: "cached_deployments"),
              let cachedDeployments = try? JSONDecoder().decode([Deployment].self, from: data) else {
            print("📭 No cached deployments found")
            return
        }
        
        print("📦 Loaded \(cachedDeployments.count) cached deployments")
        deployments = cachedDeployments
        errorMessage = nil
    }
    
    deinit {
        stopPolling()
    }
}