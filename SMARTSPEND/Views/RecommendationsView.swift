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
            VStack(spacing: 20) {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                        .multilineTextAlignment(.center)
                } else {
                    VStack(alignment: .leading, spacing: 15) {
                        // Title with a subtle gradient background
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.title)
                            Text("Your Recommendations")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.2)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 15) {
                                Text(recommendationText)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    )
                                    .multilineTextAlignment(.leading)
                                    .font(.body)
                                    .padding(.top, 20) // Move the text a bit lower
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 10)
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                Spacer()
            }
            .onAppear {
                fetchRecommendations()
            }
            .navigationTitle("Recommendations")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.sand) // Set the background to sand color
            .edgesIgnoringSafeArea(.bottom) // Make sure it covers the whole screen except the top
        }
    }
}

// Decodable structure for API response
struct RecommendationResponse: Decodable {
    let recommendationText: String
}

struct RecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsView()
    }
}
