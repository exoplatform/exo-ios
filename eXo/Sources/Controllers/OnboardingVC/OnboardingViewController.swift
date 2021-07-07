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
    @IBOutlet weak var pageControl: UIStackView!
    @IBOutlet weak var flotView: DesignableView!
    @IBOutlet weak var pageControlView: UIView!
    @IBOutlet weak var slideTitleLabel: UILabel!
    
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
        scanButton.addCornerRadiusWith(radius: 5)
        onboardngCollectionView.delegate = self
        onboardngCollectionView.dataSource = self
        onboardngCollectionView.register(OnboardingCell.nib(), forCellWithReuseIdentifier: OnboardingCell.cellId)
        flotView.frame.origin.x = -(flotView.frame.size.width/2)/2
        setupPageControl(page:currentPage + 1)
        slideTitleLabel.text = onboardingList[0].title

    }
    
    @IBAction func addServerTapped(_ sender: Any) {
        let signInToeXo = ConnectToExoViewController(nibName: "ConnectToExoViewController", bundle: nil)
        navigationController?.pushViewController(signInToeXo, animated: false)
    }
    
    func setupPageControl(page:Int){
        let centerX = self.flotView.frame.size.width/2
        UIView.animate(withDuration: 0.5) {
            switch page {
            case 1:
                self.flotView.frame.origin.x = -centerX/2
            case 2:
                self.flotView.frame.origin.x = self.pageControlView.frame.size.width/2 - centerX
            case 3:
                self.flotView.frame.origin.x = self.pageControlView.frame.size.width - 1.5*centerX
            default:
                self.flotView.frame.origin.x = -centerX
            }
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
        currentPage = Int(scrollView.contentOffset.x / width) + 1
        slideNumberLabel.text = "\(currentPage)"
        setupPageControl(page:currentPage)
        slideTitleLabel.text = onboardingList[currentPage - 1].title
    }
}
