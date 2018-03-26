//
//  WelcomeViewController.swift
//  eXo
//
//  Created by Nguyen Manh Toan on 10/15/15.

// Copyright (C) 2003-2015 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.

import UIKit


class WelcomeViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // the number of slides in the presentation
    let kNumberOfPage = 4
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.clipsToBounds = true
        Tool.applyBorderForView(getStartedButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // the navigation controller is alway hidden in this screen
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.topViewController?.title = ""
    }
    
    @IBAction func closeWelcomeView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
    
    // MARK: - Page View Delegate & Data Source
    
    func welcomePageAtIndex(_ index : Int) -> UIViewController? {
        if (index < 0 || index >= kNumberOfPage) {
            return nil
        }
        // the slide will be made in storyboard with id = welcomePage1-4 ...
        let storyboardId = "welcomePage\(index+1)"
        let welcomepage = self.storyboard?.instantiateViewController(withIdentifier: storyboardId)
        // store the index of the slide in view.tag
        welcomepage?.view.tag = index
        return welcomepage!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self.welcomePageAtIndex(viewController.view.tag-1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return self.welcomePageAtIndex(viewController.view.tag+1)
    }

    //Spines
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return kNumberOfPage
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return (pageViewController.viewControllers?.last?.view.tag)!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation 
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // embeded segue of the container view
        if (segue.identifier == "wellcomePageSegue") {
            let pageViewController = segue.destination as? UIPageViewController
            pageViewController?.delegate = self
            pageViewController?.dataSource = self
            pageViewController?.setViewControllers([ self.welcomePageAtIndex(0)!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

            // customize the spine's dots & background
            let pageControl = UIPageControl.appearance()
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            pageControl.currentPageIndicatorTintColor = Config.eXoYellowColor
            pageControl.backgroundColor = UIColor.clear


        }
    }

}
