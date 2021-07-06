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
    
    // MARK: - Variables .

    var onboardingList:[OnboardingItem] = []
    var currentPage:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func initView() {
        onboardingList = [
            OnboardingItem(title: "OnBoarding.Title.ShowQRCode".localized, image: "qr_code_scanner"),
            OnboardingItem(title: "OnBoarding.Title.ScanQRsettings".localized, image: "qr_code_scanner"),
            OnboardingItem(title: "OnBoarding.Title.EnterPassword".localized, image: "qr_code_scanner")
        ]
        scanButton.setTitle("OnBoarding.Title.ScanCode".localized, for: .normal)
        addServerButton.setTitle("OnBoarding.Title.EnterUrleXo".localized, for: .normal)
        addServerButton.addCornerRadiusWith(radius: 5)
        onboardngCollectionView.delegate = self
        onboardngCollectionView.dataSource = self
        onboardngCollectionView.register(OnboardingCell.nib(), forCellWithReuseIdentifier: OnboardingCell.cellId)
    }
    
    @IBAction func addServerTapped(_ sender: Any) {
        let signInToeXo = ConnectToExoViewController(nibName: "ConnectToExoViewController", bundle: nil)
        navigationController?.pushViewController(signInToeXo, animated: false)
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
        currentPage = Int(scrollView.contentOffset.x / width) + 1
        slideNumberLabel.text = "\(currentPage)"
    }
}
