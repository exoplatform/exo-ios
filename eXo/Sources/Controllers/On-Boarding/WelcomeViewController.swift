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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // the navigation controller is alway hidden in this screen
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.topViewController?.title = ""
    }
    
    @IBAction func closeWelcomeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    // MARK: - Page View Delegate & Data Source
    
    func welcomePageAtIndex(index : Int) -> UIViewController? {
        if (index < 0 || index >= kNumberOfPage) {
            return nil
        }
        // the slide will be made in storyboard with id = welcomePage0, welcomePage1 ...
        let storyboardId = "welcomePage\(index)"
        let welcomepage = self.storyboard?.instantiateViewControllerWithIdentifier(storyboardId)
        // store the index of the slide in view.tag
        welcomepage?.view.tag = index
        return welcomepage!
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return self.welcomePageAtIndex(viewController.view.tag-1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return self.welcomePageAtIndex(viewController.view.tag+1)
    }

    //Spines
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return kNumberOfPage
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return (pageViewController.viewControllers?.last?.view.tag)!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation 
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        // embeded segue of the container view
        if (segue.identifier == "wellcomePageSegue") {
            let pageViewController = segue.destinationViewController as? UIPageViewController
            pageViewController?.delegate = self
            pageViewController?.dataSource = self
            pageViewController?.setViewControllers([ self.welcomePageAtIndex(0)!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)

            // customize the spine's dots & background
            let pageControl = UIPageControl.appearance()
            pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
            pageControl.currentPageIndicatorTintColor = UIColor(red: 250.0/255, green: 210.0/255, blue: 20.0/255, alpha: 1.0)
            pageControl.backgroundColor = UIColor.clearColor()


        }
    }

}
