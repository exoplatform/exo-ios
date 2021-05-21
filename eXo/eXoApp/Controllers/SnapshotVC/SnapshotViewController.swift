//
//  SnapshotViewController.swift
//  eXo
//
//  Created by eXo Development on 03/05/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class SnapshotViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var snapshotTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        snapshotTableView.delegate = self
        snapshotTableView.dataSource = self
        snapshotTableView.register(NewsCell.nib(), forCellReuseIdentifier: NewsCell.cellId)
        snapshotTableView.register(WelcomeBackCell.nib(), forCellReuseIdentifier: WelcomeBackCell.cellId)
        snapshotTableView.register(MyOrderWalletCell.nib(), forCellReuseIdentifier: MyOrderWalletCell.cellId)
        snapshotTableView.register(AgendaCell.nib(), forCellReuseIdentifier: AgendaCell.cellId)
        snapshotTableView.register(TasksCell.nib(), forCellReuseIdentifier: TasksCell.cellId)
        snapshotTableView.register(DocumentsCell.nib(), forCellReuseIdentifier: DocumentsCell.cellId)
        snapshotTableView.estimatedRowHeight = 100
        snapshotTableView.rowHeight = UITableView.automaticDimension
    }
    
}

extension SnapshotViewController:UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - TableView Delegates.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellId, for: indexPath) as! NewsCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: WelcomeBackCell.cellId, for: indexPath) as! WelcomeBackCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyOrderWalletCell.cellId, for: indexPath) as! MyOrderWalletCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.cellId, for: indexPath) as! AgendaCell
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: TasksCell.cellId, for: indexPath) as! TasksCell
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: DocumentsCell.cellId, for: indexPath) as! DocumentsCell
            return cell
        default:
            return UITableViewCell()
        }
    }

}
