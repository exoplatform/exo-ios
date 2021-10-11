//
//  ConnectToExoViewController.swift
//  eXo
//
//  Created by eXo Development on 10/06/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit
import Kingfisher

class ConnectToExoViewController: UIViewController {
    
    // MARK: - Outlets.
    
    @IBOutlet weak var connectTableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    // MARK: - Variables.
    
    var selectedServer:Server?
    var server:Server!
    var countLoggedOut:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addObserverWith(selector: #selector(deleteTapped(notification:)), name: .deleteInstance)
        addObserverWith(selector: #selector(reloadNotifData(notification:)), name: .reloadTableView)
        connectTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        AppUtility.lockOrientation(.portrait)
        connectTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        AppUtility.lockOrientation(.all)
    }
    
    @objc
    func deleteTapped(notification:Notification){
        if ServerManager.sharedInstance.serverList.count == 0 {
            rootToOboarding()
        }
        self.connectTableView.reloadData()
    }
    
    @objc
    func reloadNotifData(notification:Notification){
        DispatchQueue.main.async {
            self.connectTableView.reloadData()
        }
    }
    
    @objc
    func popVC(){
        goBack()
    }
    
    @objc
    func addButtonTapped(){
        rootToOboarding()
    }
    
    func rootToOboarding(){
        let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
        appDelegate.setRootOnboarding()
    }
    
    @objc
    func deleteButtonTapped(_ sender:UIButton){
        let title = "Setting.Title.DeleteServer".localized
        let msg = "Setting.Message.DeleteServer".localized
        if let serverToDelete = ServerManager.sharedInstance.serverList[sender.tag] as? Server {
            print("serverToDelete === >  \(serverToDelete)")
            showAlertMessageDelete(title:title,msg: msg, action: .delete, server: serverToDelete)
        }
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
        if (ServerManager.sharedInstance.serverList != nil) {
            return ServerManager.sharedInstance.serverList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView()
        viewHeader.backgroundColor = .white
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderConnectCell.cellId) as! HeaderConnectCell
        headerCell.headerButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServerCell.cellId, for: indexPath) as! ServerCell
        let serveur = (ServerManager.sharedInstance.serverList?[indexPath.row] as! Server).serverURL.stringURLWithoutProtocol()
        cell.setupDataWith(serveur:serveur)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_ :)), for: .touchUpInside)
        cell.badgeView.isHidden = true
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
<<<<<<< HEAD
=======
          //  UserDefaults.standard.setValue(self.selectedServer?.serverURL, forKey: "serverURL")
>>>>>>> 727b91b (49271 : Redirection to the card Screen update (#109))
            self.connectTableView.reloadData()
            navigationController?.navigationBar.isHidden = false
            if isInternetConnected(inWeb: false) {
                navigationController?.pushViewController(homepageVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

