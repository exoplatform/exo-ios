//
//  ConnectToExoViewController.swift
//  eXo
//
//  Created by eXo Development on 10/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class ConnectToExoViewController: UIViewController {

    // MARK: - Outlets.
    
    @IBOutlet weak var connectTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = NSLocalizedString("OnBoarding.Title.SignInToeXo", comment:"")
        self.navigationController?.isNavigationBarHidden = false
        setNavigationBarAppearance()
    }
    
    func setNavigationBarAppearance(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0xF0F0F0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        var yourBackImage = UIImage(named: "goBack")
        if #available(iOS 13.0, *) {
             yourBackImage = UIImage(named: "goBack")?.withTintColor(UIColor(hex: 0xF0F0F0))
        }
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    func initView() {
        connectTableView.delegate = self
        connectTableView.dataSource = self
        connectTableView.register(HeaderConnectCell.nib(), forCellReuseIdentifier: HeaderConnectCell.cellId)
        connectTableView.register(ServerCell.nib(), forCellReuseIdentifier: ServerCell.cellId)
    }
}

extension ConnectToExoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderConnectCell.cellId) as! HeaderConnectCell
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServerCell.cellId, for: indexPath) as! ServerCell
        cell.setupDataWith()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

