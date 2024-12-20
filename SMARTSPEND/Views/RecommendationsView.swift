import SwiftUI

struct RecommendationsView: View {
    @State private var recommendationText: String = "Loading recommendations..."
    @State private var errorMessage: String? = nil
    
    // Get the current date in yyyy/MM format
    func getCurrentPeriod() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM"
        return dateFormatter.string(from: Date())
    }
    
    // Fetch recommendations for the connected user
    func fetchRecommendations() {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            self.errorMessage = "User token not found."
            self.recommendationText = "Unable to load recommendations."
            return
        }
        
        // Construct the URL with the current month and year
        let period = getCurrentPeriod()
        let urlString = "http://localhost:3000/recommendations/generate?userToken=\(token)&period=\(period)"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL."
            self.recommendationText = "Unable to load recommendations."
            return
        }
        
        // Perform the request
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.recommendationText = "Unable to load recommendations."
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received."
                    self.recommendationText = "Unable to load recommendations."
                    return
                }
                
                do {
                    // Decode the response
                    let decodedResponse = try JSONDecoder().decode(RecommendationResponse.self, from: data)
                    self.recommendationText = decodedResponse.recommendationText
                } catch {
                    self.errorMessage = "Failed to decode response."
                    self.recommendationText = "Unable to load recommendations."
                }
            }
        }.resume()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(gradient: Gradient(colors: [.sand, .sand.opacity(0.6)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    Text("Recommended Actions")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.mostImportantColor)
                        .padding(.top, 30)
                        .padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 15) {
                            // Example recommendation card
                            RecommendationCard(
                                title: "Reduce Dining Out",
                                message: "Cut back on restaurant expenses by cooking at home more often.",
                                color: .teal
                            )
                            RecommendationCard(
                                title: "Cancel Unused Subscriptions",
                                message: "Review all your monthly subscriptions and cancel those you barely use.",
                                color: .navy
                            )
                            RecommendationCard(
                                title: "Use Cashback Apps",
                                message: "Try cashback or coupon apps to save on regular purchases.",
                                color: .red
                            )
                            RecommendationCard(
                                title: "Consider Carpooling",
                                message: "Share rides for daily commutes to save on fuel and maintenance costs.",
                                color: .leastImportantColor
                            )
                            // ...existing code or more cards...
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitle("Recommendations", displayMode: .inline)
        }
    }
}

// Decodable structure for API response
struct RecommendationResponse: Decodable {
    let recommendationText: String
}

struct RecommendationCard: View {
    let title: String
    let message: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))

        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.8))
        .cornerRadius(12)
        .shadow(color: color.opacity(0.4), radius: 4, x: 2, y: 2)
    }
}

struct RecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsView()
    }
}
