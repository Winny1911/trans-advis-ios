//
//  ProjectHOVC.swift
//  TA
//
//  Created by Dev on 09/12/21.
//

import UIKit

class ProjectHOVC: BaseViewController {
    
    var pageviewcontroller:UIPageViewController!
    var ViewControllers: [BaseViewController] = [BaseViewController]()
    var currentPageIndex = 0
    var nextPageIndex = 0
    
    let viewModel: ProjectHOVM = ProjectHOVM()

    //@IBOutlet weak var btnArchieved: UIButton!
    @IBOutlet weak var btnPast: UIButton!
    @IBOutlet weak var btnOngoing: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var ongoingView: UIView!
    @IBOutlet weak var pastView: UIView!
   // @IBOutlet weak var archiveView: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllInboxMessagesForRedDot()
        self.inboxMessagesss = fireBaseChatInbox().getAllInboxMessages()
        self.navigationController?.navigationBar.isHidden = true
        self.pageviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "PageViewControllerLeader") as? UIPageViewController
//        self.pageviewcontroller.dataSource = self
//        self.pageviewcontroller.delegate = self
                
        if let newVC = Controllers.newHO{
            ViewControllers.append(newVC)
        }
        if let ongoingVC = Controllers.ongoingHO{
            ViewControllers.append(ongoingVC)
        }
        if let pastVC = Controllers.pastHO{
            ViewControllers.append(pastVC)
        }
//        if let archiveVC = Controllers.archiveHO{
//            ViewControllers.append(archiveVC)
//        }
        if let firstViewController = ViewControllers.first {
             self.pageviewcontroller.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        self.viewContainer.addSubview(pageviewcontroller.view)
        self.pageviewcontroller.view.frame = CGRect(x: 0, y: 0, width: self.viewContainer.frame.width, height: self.viewContainer.frame.height)
        self.addChild(pageviewcontroller)
        self.pageviewcontroller.didMove(toParent: self)

        self.btnColorSelected(selectedBtn: btnNew, unSelectedBtn1: btnOngoing, unSelectedBtn2: btnPast)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "NewDetailsHOVC") as? NewDetailsHOVC
//        destinationViewController?.completionHandlerGoToOngoingProjectListScreen = { [weak self] in
//            self!.goToOngoingProjects()
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToOngoingProjectListScreen(notification:)), name: Notification.Name("GoToOngoingProjectListScreen"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bidPlacedToHomeOwnerProjects(notification:)), name: Notification.Name("BidPlacedToHomeOwnerProjects"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.progressUpdateToHomeOwnerOngoingProjects(notification:)), name: Notification.Name("ProgressUpdateToHomeOwnerOngoingProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.markCompletedToHomeOwnerOngoingProjects(notification:)), name: Notification.Name("MarkCompletedToHomeOwnerOngoingProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recallBidToHomeOwnerNewProjects(notification:)), name: Notification.Name("RecallBidToHomeOwnerNewProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.projectAdminAcceptedToHomeOwnerOngoingProjects(notification:)), name: Notification.Name("ProjectAdminAcceptedToHomeOwnerOngoingProjects"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.taskUpdatedToHomeOwnerOngoingProjects(notification:)), name: Notification.Name("TaskUpdatedToHomeOwnerOngoingProjects"), object: nil)
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
    
    @objc func taskUpdatedToHomeOwnerOngoingProjects(notification: Notification) {
        self.goToOngoingProjects()
        NotificationCenter.default.post(name: Notification.Name("TaskUpdatedToHomeOwnerOngoingProjectsDetails"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func projectAdminAcceptedToHomeOwnerOngoingProjects(notification: Notification) {
        self.goToOngoingProjects()
        NotificationCenter.default.post(name: Notification.Name("ProjectAdminAcceptedToHomeOwnerOngoingProjectsDetails"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func recallBidToHomeOwnerNewProjects(notification: Notification) {
        if let firstViewController = ViewControllers.first{
            newView.backgroundColor = UIColor.appColorGreen
            ongoingView.backgroundColor = UIColor.lightGray
            pastView.backgroundColor = UIColor.lightGray
           // archiveView.backgroundColor = UIColor.lightGray
            self.currentPageIndex = 0
            self.btnColorSelected(selectedBtn: btnNew, unSelectedBtn1: btnOngoing, unSelectedBtn2: btnPast)
            self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
            NotificationCenter.default.post(name: Notification.Name("RecallBidToHomeOwnerNewProjectsDetails"), object: nil, userInfo: notification.userInfo!)
        }
    }
    
    @objc func markCompletedToHomeOwnerOngoingProjects(notification: Notification) {
        self.goToOngoingProjects()
        NotificationCenter.default.post(name: Notification.Name("MarkCompletedToHomeOwnerOngoingProjectsDetails"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func progressUpdateToHomeOwnerOngoingProjects(notification: Notification) {
        self.goToOngoingProjects()
        NotificationCenter.default.post(name: Notification.Name("ProgressUpdateToHomeOwnerOngoingProjectsDetails"), object: nil, userInfo: notification.userInfo!)
    }
    
    @objc func bidPlacedToHomeOwnerProjects(notification: Notification) {
        if let firstViewController = ViewControllers.first{
            newView.backgroundColor = UIColor.appColorGreen
            ongoingView.backgroundColor = UIColor.lightGray
            pastView.backgroundColor = UIColor.lightGray
           // archiveView.backgroundColor = UIColor.lightGray
            self.currentPageIndex = 0
            self.btnColorSelected(selectedBtn: btnNew, unSelectedBtn1: btnOngoing, unSelectedBtn2: btnPast)
            self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
            NotificationCenter.default.post(name: Notification.Name("BidPlacedToHomeOwnerProjectsDetails"), object: nil, userInfo: notification.userInfo!)
        }
    }
    
    @objc func goToOngoingProjectListScreen(notification: Notification) {
        self.goToOngoingProjects()
    }

    
    //MARK: - SELECTED CHOICE
    func selectedChoice() {
        if currentPageIndex == 0 {
            newView.backgroundColor = UIColor.appColorGreen
            ongoingView.backgroundColor = UIColor.lightGray
            pastView.backgroundColor = UIColor.lightGray
            //archiveView.backgroundColor = UIColor.lightGray
        } else if currentPageIndex == 1 {
            ongoingView.backgroundColor = UIColor.appColorGreen
            newView.backgroundColor = UIColor.lightGray
            pastView.backgroundColor = UIColor.lightGray
            //archiveView.backgroundColor = UIColor.lightGray
        } else if currentPageIndex == 2 {
            pastView.backgroundColor = UIColor.appColorGreen
            newView.backgroundColor = UIColor.lightGray
            ongoingView.backgroundColor = UIColor.lightGray
           // archiveView.backgroundColor = UIColor.lightGray
        }  else if currentPageIndex == 3 {
           // archiveView.backgroundColor = UIColor.appColorGreen
            newView.backgroundColor = UIColor.lightGray
            pastView.backgroundColor = UIColor.lightGray
            ongoingView.backgroundColor = UIColor.lightGray
        }
    }
    
    func btnColorSelected(selectedBtn:UIButton, unSelectedBtn1:UIButton, unSelectedBtn2:UIButton) {
        selectedBtn.setTitleColor(UIColor.appColorText, for: .normal)
        unSelectedBtn1.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
        unSelectedBtn2.setTitleColor(UIColor.appUnSelectedBlack, for: .normal)
    }
    
    @IBAction func newBtnDidTab(_ sender: Any) {
        if let firstViewController = ViewControllers.first{
            newView.backgroundColor = UIColor.appColorGreen
            ongoingView.backgroundColor = UIColor.lightGray
            pastView.backgroundColor = UIColor.lightGray
            self.currentPageIndex = 0
            self.btnColorSelected(selectedBtn: btnNew, unSelectedBtn1: btnOngoing, unSelectedBtn2: btnPast)
            self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
        }
    }
    
    func goToOngoingProjects() {
        let firstViewController = ViewControllers[1]
        ongoingView.backgroundColor = UIColor.appColorGreen
        newView.backgroundColor = UIColor.lightGray
        pastView.backgroundColor = UIColor.lightGray

        self.currentPageIndex = 1
        self.btnColorSelected(selectedBtn: btnOngoing, unSelectedBtn1: btnNew, unSelectedBtn2: btnPast)
        self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
    }
    
    
    @IBAction func ongoingBtnDidTap(_ sender: Any) {
        goToOngoingProjects()
    }

    @IBAction func pastBtnDidTap(_ sender: Any) {
        let firstViewController = ViewControllers[2]
        pastView.backgroundColor = UIColor.appColorGreen
        newView.backgroundColor = UIColor.lightGray
        ongoingView.backgroundColor = UIColor.lightGray

        self.currentPageIndex = 2
        self.btnColorSelected(selectedBtn: btnPast, unSelectedBtn1: btnNew, unSelectedBtn2: btnOngoing)
        self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
    }

    @IBAction func archiveBtnDidTap(_ sender: Any) {
//        let firstViewController = ViewControllers[3]
//        archiveView.backgroundColor = UIColor.appColorGreen
//        newView.backgroundColor = UIColor.lightGray
//        pastView.backgroundColor = UIColor.lightGray
//        ongoingView.backgroundColor = UIColor.lightGray
//        self.currentPageIndex = 3
//        self.btnColorSelected(selectedBtn: btnArchieved, unSelectedBtn1: btnNew, unSelectedBtn2: btnOngoing, unSelectedBtn3: btnPast)
//        self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
    }
    
    @IBAction func notificationBtnAction(_ sender: Any) {
        let vc = Storyboard.projectHO.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ProjectHOVC: UIPageViewControllerDelegate{
    
}

extension ProjectHOVC: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = ViewControllers.firstIndex(of: viewController as! BaseViewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard ViewControllers.count > previousIndex else {
            return nil
        }
        return ViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = ViewControllers.firstIndex(of: viewController as! BaseViewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let ViewControllersCount = ViewControllers.count
        guard ViewControllersCount != nextIndex else {
            return nil
        }
        guard ViewControllersCount > nextIndex else {
            return nil
        }
        return ViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed) {
            return
          }
          //self.currentPageIndex = pageViewController.viewControllers!.first!.view.tag
        if pageViewController.viewControllers?.first == ViewControllers[0]{
            nextPageIndex = 0
        } else if pageViewController.viewControllers?.first == ViewControllers[1]{
            nextPageIndex = 1
        } else if pageViewController.viewControllers?.first == ViewControllers[2]{
            nextPageIndex = 2
        } else if pageViewController.viewControllers?.first == ViewControllers[3]{
            nextPageIndex = 3
        }
        currentPageIndex = nextPageIndex
        self.selectedChoice()
    }
}
