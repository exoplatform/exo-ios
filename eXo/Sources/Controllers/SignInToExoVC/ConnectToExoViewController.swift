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
    
    // MARK: - Outlets.

    var selectedServer : Server?

    override func viewDidLoad() {
        super.viewDidLoad()
       initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarAppearance()
    }
    
    func setNavigationBarAppearance(){
        self.navigationItem.title = NSLocalizedString("OnBoarding.Title.SignInToeXo", comment:"")
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0xF0F0F0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        //MARK:- menuButton
        let menuButton = UIButton(type: .system)
        menuButton.setBackgroundImage(UIImage(named: "goBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        menuButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        menuButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        let rightBarButtonItem3 = UIBarButtonItem()
        rightBarButtonItem3.customView = menuButton
        navigationItem.setLeftBarButtonItems([rightBarButtonItem3], animated: true)
    }
    
    @objc
    func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func addButtonTapped(){
        let addDomainVC = AddDomainViewController()
        self.present(addDomainVC, animated: true)
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
        if ( ServerManager.sharedInstance.serverList != nil) {
            return ServerManager.sharedInstance.serverList!.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderConnectCell.cellId) as! HeaderConnectCell
        headerCell.headerButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServerCell.cellId, for: indexPath) as! ServerCell
        let serveur = (ServerManager.sharedInstance.serverList?[indexPath.row] as! Server).serverURL.stringURLWithoutProtocol()
            cell.setupDataWith(serveur:serveur)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.selectedServer = ServerManager.sharedInstance.serverList?[indexPath.row] as? Server
       self.selectedServer?.lastConnection = Date().timeIntervalSince1970
        ServerManager.sharedInstance.addEditServer(self.selectedServer!)
        // Open the selected server in the WebView
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let homepageVC = sb.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController
        if let homepageVC = homepageVC {
            homepageVC.serverURL = self.selectedServer?.serverURL
            UserDefaults.standard.setValue(self.selectedServer?.serverURL, forKey: "serverURL")
            self.connectTableView.reloadData()
            navigationController?.pushViewController(homepageVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

