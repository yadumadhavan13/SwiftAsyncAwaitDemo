//
//  ViewController.swift
//  SwiftAsyncAwaitDemo
//
//  Created by YADU MADHAVAN on 13/09/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")
    
    private var users = [Users]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        Task { [weak self] in
            let users = await fetchUsers()
            self?.users = users
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func fetchUsers() async -> [Users] {
        guard let url = url else {
            return []
        }
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let users = try JSONDecoder().decode([Users].self, from: data)
            return users
        } catch {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}

