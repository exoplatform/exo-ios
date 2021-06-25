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
    
    var selectedServer : Server?
    var server:Server!

    override func viewDidLoad() {
        super.viewDidLoad()
       initView()
       connectTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        connectTableView.reloadData()
      //  setNavigationBarAppearance()
    }
    
    func setNavigationBarAppearance(){
        self.navigationItem.title = "OnBoarding.Title.SignInToeXo".localized
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: 0xF0F0F0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        //MARK:- Back Button
        let backButton = UIButton(type: .system)
        backButton.setBackgroundImage(UIImage(named: "goBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let rightBarButtonItem3 = UIBarButtonItem()
        rightBarButtonItem3.customView = backButton
        navigationItem.setLeftBarButtonItems([rightBarButtonItem3], animated: true)
    }
    
    @objc
    func popVC(){
        goBack()
    }
    
    @objc
    func addButtonTapped(){
        let addDomainVC = AddDomainViewController()
        addDomainVC.modalPresentationStyle = .overFullScreen
        self.present(addDomainVC, animated: true)
       // goBack()
    }
  
    @objc
    func deleteButtonTapped(_ sender:UIButton){
        let _server = ServerManager.sharedInstance.serverList[sender.tag] as! Server
        self.deleteServer(server: _server)
    }
    
    func initView() {
        connectTableView.delegate = self
        connectTableView.dataSource = self
        connectTableView.register(HeaderConnectCell.nib(), forCellReuseIdentifier: HeaderConnectCell.cellId)
        connectTableView.register(ServerCell.nib(), forCellReuseIdentifier: ServerCell.cellId)
        addObserverWith(selector: #selector(openServer(notification:)), name: .addDomainKey)
    }
    
    @objc
    func openServer(notification:Notification){
        connectTableView.reloadData()
        guard let serverURL = notification.userInfo?["serverURL"] as? String else { return }
        // Open the selected server in the WebView
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let homepageVC = sb.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController
        if let homepageVC = homepageVC {
            homepageVC.serverURL = serverURL
            self.navigationController?.pushViewController(homepageVC, animated: true)
        }
    }
    
    func deleteServer(server:Server) {
        //Ask for confirmation first
        let alertController = UIAlertController(title:"Setting.Title.DeleteServer".localized, message: "Setting.Message.DeleteServer".localized, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Word.Cancel", comment: ""), style: UIAlertAction.Style.cancel) { (cancelAction) -> Void in
        }
        alertController.addAction(cancelAction)
        let confirmAction = UIAlertAction(title:"Word.OK".localized, style: UIAlertAction.Style.destructive) { (confirmAction) -> Void in
            ServerManager.sharedInstance.removeServer(server);
            if ServerManager.sharedInstance.serverList.count == 0 {
                self.navigationController?.popViewController(animated: true)
            }
            self.connectTableView.reloadData()
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: false, completion: nil)
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
        if let dic = defaults.dictionary(forKey: "badgeNumber") {
            if let badgeNumber = dic[serveur] as? Int {
                print(badgeNumber)
                if badgeNumber != 0 {
                    cell.badgeView.isHidden = false
                    cell.badgeLabel.text = "\(badgeNumber)"
                }else{
                    cell.badgeView.isHidden = true
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

