//
//  StreamViewController.swift
//  Stream eXo
//
//  Created by eXo Development on 20/05/2021.
//

import UIKit

class StreamViewController: UIViewController {

    // MARK: - Outlets.
    
    @IBOutlet weak var streamTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        let username = "wajih_benabdessalem"
        let password = "wajwaj1989"
        APIManager.sharedInstance.getActivitiesApi(username: username, password: password)
    }
    
    func initView() {
        streamTableView.delegate = self
        streamTableView.dataSource = self
        streamTableView.register(ContainerActivityCell.nib(), forCellReuseIdentifier: ContainerActivityCell.cellId)
    }
}

extension StreamViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContainerActivityCell.cellId, for: indexPath) as! ContainerActivityCell
        return cell
    }
}

