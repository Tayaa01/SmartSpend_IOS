import SwiftUI

// Add models for the API response
struct Suggestion: Codable, Identifiable {
    let category: String
    let advice: String
    var id: String { category } // Use category as id since it appears unique
}

struct RecommendationResponse: Codable {
    let suggestions: [Suggestion]
    let user: String
    let date: String
    let _id: String
    let __v: Int
}

struct RecommendationsView: View {
    @StateObject private var viewModel = RecommendationsViewModel()
    
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
                    
                    if viewModel.isLoading {
                        ProgressView("Loading recommendations...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(viewModel.recommendations) { suggestion in
                                    RecommendationCard(
                                        title: suggestion.category,
                                        message: suggestion.advice,
                                        color: getColorForCategory(suggestion.category)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationBarTitle("Recommendations", displayMode: .inline)
            .onAppear {
                viewModel.fetchRecommendations()
            }
        }
    }
    
    private func getColorForCategory(_ category: String) -> Color {
        switch category {
        case "Expense Management":
            return .teal // Use our custom teal color
        case "Debt Reduction":
            return .red // Use our custom red color
        case "Emergency Fund":
            return .navy // Use our custom navy color
        case "Financial Planning":
            return .mostImportantColor // Use our custom mostImportantColor
        default:
            return .leastImportantColor // Use our custom leastImportantColor
        }
    }
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
