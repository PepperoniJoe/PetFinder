//
//  ViewController.swift
//  PetFinder
//
//  Created by Marcy Vernon on 8/1/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let dogBreeds      = DogBreeds()
    var breeds: [(section: String, details: [String])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        dogBreeds.fetchBreeds()
    }
    
    func setDelegates() {
        tableView.delegate   = self
        tableView.dataSource = self
        dogBreeds.delegate   = self
    }

} // end of View Controller


// Formats data for list by section
extension ViewController: BreedList {
    func displayBreedList() {
        var dict: [String: [String]] = [:]

        if let breeds = dogBreeds.breeds {
            for breed in breeds {
                let name = breed.name ?? ""
                if name != "" {
                  let initial = name.prefix(1).capitalized
                  dict[initial, default: []].append(name)
                }
            }
            
            for (key, value) in dict {
                self.breeds.append((section: key, details: value))
            }
            
            self.breeds.sort(by: { $0.section < $1.section } )
            self.breeds.map{ $0.details }.sorted(by: { $0 < $1 } )
        }
        tableView.reloadData()
    }
    
    func displayTestData() {
        self.breeds = TestFile.testArray
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return breeds[section].section
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds[section].details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = breeds[indexPath.section].details[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {}


