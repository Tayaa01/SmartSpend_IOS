import Foundation

class AuthService {
    static let shared = AuthService()

    enum AuthServiceError: Error {
        case networkError
        case invalidCredentials
        case serverError
        
        var localizedDescription: String {
            switch self {
            case .networkError:
                return "Network error. Please try again."
            case .invalidCredentials:
                return "Invalid email or password."
            case .serverError:
                return "Server error. Please try again later."
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let url = URL(string: "http://localhost:3000/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(AuthServiceError.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(AuthServiceError.networkError))
                return
            }
            
            // Handle HTTP status codes
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(AuthServiceError.serverError))
                return
            }
            
            // Decode the response data into UserModel
            do {
                let user = try JSONDecoder().decode(UserModel.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(AuthServiceError.invalidCredentials))
            }
        }.resume()
    }

    func signUp(name: String, email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let url = URL(string: "http://localhost:3000/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "name": name,
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(AuthServiceError.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(AuthServiceError.networkError))
                return
            }
            
            // Handle HTTP status codes
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(AuthServiceError.serverError))
                return
            }
            
            // Decode the response data into UserModel
            do {
                let user = try JSONDecoder().decode(UserModel.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(AuthServiceError.invalidCredentials))
            }
        }.resume()
    }
}


