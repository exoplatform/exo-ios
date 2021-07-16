//
//  OnboardingViewController.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 5/7/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - Outlets .
    
    @IBOutlet weak var onboardngCollectionView: UICollectionView!
    @IBOutlet weak var slideNumberLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var addServerButton: UIButton!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Variables .
    var onboardingList:[OnboardingItem] = []
    var onboardingEnList:[OnboardingItem] = []
    var onboardingFrList:[OnboardingItem] = []
    var qrCodeServer : Server?
    var currentPage:Int = 0
    var nextScroll:CGFloat = 0
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        AppUtility.lockOrientation(.portrait)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func initView() {
        onboardingFrList = [
            OnboardingItem(title: "OnBoarding.Title.ShowQRCode".localized, image: "slide1_gif-FR"),
            OnboardingItem(title: "OnBoarding.Title.ScanQRsettings".localized, image: "slide2_gif-FR"),
            OnboardingItem(title: "OnBoarding.Title.EnterPassword".localized, image: "slide3_gif-FR")
        ]
        onboardingEnList = [
            OnboardingItem(title: "OnBoarding.Title.ShowQRCode".localized, image: "slide1_gif-EN"),
            OnboardingItem(title: "OnBoarding.Title.ScanQRsettings".localized, image: "slide2_gif-EN"),
            OnboardingItem(title: "OnBoarding.Title.EnterPassword".localized, image: "slide3_gif-EN")
        ]
        if let lang = Locale.current.languageCode {
            onboardingList = lang == "en" ? onboardingEnList : onboardingFrList
        }
        scanButton.setTitle("OnBoarding.Title.ScanCode".localized, for: .normal)
        addServerButton.setTitle("OnBoarding.Title.EnterUrleXo".localized, for: .normal)
        scanButton.addCornerRadiusWith(radius: 5)
        onboardngCollectionView.delegate = self
        onboardngCollectionView.dataSource = self
        onboardngCollectionView.register(OnboardingCell.nib(), forCellWithReuseIdentifier: OnboardingCell.cellId)
        pageControl.numberOfPages = onboardingList.count
        slideTitleLabel.text = onboardingList[0].title
        addObserverWith(selector: #selector(rootToHome(notification:)), name: .rootFromScanURL)
        addObserverWith(selector: #selector(openServer(notification:)), name: .addDomainKey)
        startTimer()
    }

    @objc
    func openServer(notification:Notification){
        guard let serverURL = notification.userInfo?["serverURL"] as? String else { return }
        // Open the selected server in the WebView
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let homepageVC = sb.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController
        if let homepageVC = homepageVC {
            homepageVC.serverURL = serverURL
            self.navigationController?.pushViewController(homepageVC, animated: true)
        }
    }
    
    @objc
    func rootToHome(notification:Notification){
        guard let rootURL = notification.userInfo?["rootURL"] as? String else { return }
        // check Internet connection
        checkConnectivity()
        Tool.verificationServerURL(rootURL, delegate: self, handleSuccess: { (serverURL) -> Void in
            self.qrCodeServer = Server(serverURL: serverURL)
            OperationQueue.main.addOperation({ () -> Void in
                ServerManager.sharedInstance.addEditServer(self.qrCodeServer!)
                self.qrCodeServer?.lastConnection = Date().timeIntervalSince1970
                UserDefaults.standard.setValue(self.qrCodeServer?.serverURL, forKey: "serverURL")
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let homepageVC = sb.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController
                if let homepageVC = homepageVC {
                    homepageVC.serverURL = serverURL
                    self.navigationController?.pushViewController(homepageVC, animated: true)
                }
            })
        })
    }
    
    @IBAction func addServerTapped(_ sender: Any) {
        let addDomainVC = AddDomainViewController()
        addDomainVC.modalPresentationStyle = .overFullScreen
        self.present(addDomainVC, animated: true)
    }
    
    @IBAction func scanQRTapped(_ sender: Any) {
        setRootToScan()
    }
    
    func setRootToScan(){
        let signInToeXo = QRCodeScannerViewController(nibName: "QRCodeScannerViewController", bundle: nil)
        signInToeXo.modalPresentationStyle = .overFullScreen
        present(signInToeXo, animated: false, completion: nil)
    }
    
    /**
        Scroll to Next Cell
        */
    
    @objc
    func scrollToNextCell(){
        //get Collection View Instance
        //get cell size
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        //get current content Offset of the Collection view
        let contentOffset = onboardngCollectionView.contentOffset
        //scroll to next cell
        nextScroll = contentOffset.x + cellSize.width
        let count = nextScroll/cellSize.width
        if nextScroll == cellSize.width*3 {
            nextScroll = 0
            setSlideStatus(count:0)
        }
        onboardngCollectionView.scrollRectToVisible(CGRect(x: nextScroll, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        setSlideStatus(count:Int(count))
    }

       /**
        Invokes Timer to start Automatic Animation with repeat enabled
        */
    func startTimer() {
      timer = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    func setSlideStatus(count:Int) {
        switch count {
        case 0:
            slideTitleLabel.text = onboardingList[count].title
            slideNumberLabel.text = "\(count + 1)"
            pageControl.currentPage = count
        case 1:
            slideTitleLabel.text = onboardingList[count].title
            slideNumberLabel.text = "\(count + 1)"
            pageControl.currentPage = count
        case 2:
            slideTitleLabel.text = onboardingList[count].title
            slideNumberLabel.text = "\(count + 1)"
            pageControl.currentPage = count
        default:
            print(count)
        }
    
    }
}

extension OnboardingViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.cellId, for: indexPath) as! OnboardingCell
        cell.setDataWith(slide: onboardingList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        slideNumberLabel.text = "\(currentPage + 1)"
        pageControl.currentPage = currentPage
        slideTitleLabel.text = onboardingList[currentPage].title
    }
}
