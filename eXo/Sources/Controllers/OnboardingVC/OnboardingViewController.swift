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
    var currentPage:Int = 0
    var nextScroll:CGFloat = 0
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
    }
    
    func initView() {
        onboardingList = [
            OnboardingItem(title: "OnBoarding.Title.ShowQRCode".localized, image: "qr_code_scanner"),
            OnboardingItem(title: "OnBoarding.Title.ScanQRsettings".localized, image: "qr_code_scanner"),
            OnboardingItem(title: "OnBoarding.Title.EnterPassword".localized, image: "qr_code_scanner")
        ]
        scanButton.setTitle("OnBoarding.Title.ScanCode".localized, for: .normal)
        addServerButton.setTitle("OnBoarding.Title.EnterUrleXo".localized, for: .normal)
        scanButton.addCornerRadiusWith(radius: 5)
        onboardngCollectionView.delegate = self
        onboardngCollectionView.dataSource = self
        onboardngCollectionView.register(OnboardingCell.nib(), forCellWithReuseIdentifier: OnboardingCell.cellId)
        pageControl.numberOfPages = onboardingList.count
        slideTitleLabel.text = onboardingList[0].title
        addObserverWith(selector: #selector(rootToHome(notification:)), name: .rootFromScanURL)
        startTimer()
    }
    
    @objc
    func rootToHome(notification:Notification){
        guard let rootURL = notification.userInfo?["rootURL"] as? String else { return }
        let appDelegate = UIApplication.shared.delegate as! eXoAppDelegate
        appDelegate.setRootToHome(rootURL)
    }
    
    @IBAction func addServerTapped(_ sender: Any) {
        let connectToeXoVC = ConnectToExoViewController(nibName: "ConnectToExoViewController", bundle: nil)
        navigationController?.pushViewController(connectToeXoVC, animated: true)
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
        print(count)
        print(nextScroll)
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
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
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
