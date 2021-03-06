//
//  DogBreeds.swift
//  PetFinder
//
//  Created by Marcy Vernon on 8/3/20.
//

import Foundation

protocol BreedList {
    func displayBreedList()
    func displayTestData()
}

class DogBreeds {
    
    var delegate: BreedList?
    var breeds: [Breeds]? = nil
    var dispatchGroup = DispatchGroup()
    
    func fetchBreeds() {
        if Credential.clientID == "" || Credential.clientSecret == "" {
            print(Warning.testDataUsed)
            self.delegate?.displayTestData()
        } else {
            getBreeds()
        }

        dispatchGroup.notify(queue: .main) {
            self.delegate?.displayBreedList()
        }
    }
    
    private func getBreeds() {
        dispatchGroup.enter()
        guard let url  = URL(string: K.urlString.token)  else { print(Error.invalidURL); return }
        guard let body = K.bodyString.data(using: .utf8) else { print(Error.invalidBody); return }
        
    //Mark: - Create token URLRequest
        var urlRequest        = URLRequest(url : url)
        urlRequest.httpMethod = HttpMethod.post.rawValue
        urlRequest.httpBody   = body
        
        var token : String?    = nil

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            do {
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { print(Error.noData); return }
                let jsonDecoder = JSONDecoder()
                let json = try jsonDecoder.decode(Token.self, from: data)
                token = json.accessToken
                if token == nil { print(Error.noToken) }
            } catch {
                print(error.localizedDescription)
            }

            guard let url = URL(string: K.urlString.request) else { print(Error.invalidURL); return }
            
        //Mark: - Create data URLRequest using token
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HttpMethod.get.rawValue
            let value = K.bearer + (token ?? Error.noToken)
            urlRequest.addValue(value, forHTTPHeaderField: HttpHeaderField.auth.rawValue)
            
            URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                do {
                    guard error == nil else { print(error?.localizedDescription as Any); return }
                    guard let data = data else { print(Error.noData); return }
                    let jsonDecoder = JSONDecoder()
                    let json = try jsonDecoder.decode(Dog.self, from: data)
                    self?.breeds = json.breeds
                    self?.dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }.resume()
    }
    
} //end of DogBreeds
