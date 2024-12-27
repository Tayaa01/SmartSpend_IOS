import SwiftUI

class RecommendationsViewModel: ObservableObject {
    @Published var recommendations: [Suggestion] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    private var hasFetched: Bool = false
    
    func fetchRecommendations() {
        // Only fetch if we haven't already fetched during this session
        guard !hasFetched else {
            isLoading = false
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            errorMessage = "Not logged in"
            isLoading = false
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/recommendations/generate?userToken=\(token)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(RecommendationResponse.self, from: data)
                    self?.recommendations = response.suggestions
                    self?.hasFetched = true
                } catch {
                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    // Call this when you want to force a refresh of recommendations
    func refresh() {
        hasFetched = false
        isLoading = true
        fetchRecommendations()
    }
}
