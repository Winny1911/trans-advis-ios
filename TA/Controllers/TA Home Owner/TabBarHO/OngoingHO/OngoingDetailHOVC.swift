//
//  OngoingDetailHOVC.swift
//  TA
//
//  Created by Dev on 28/12/21.
//

import UIKit

class OngoingDetailHOVC: UIViewController {

    @IBOutlet weak var btnSendMsg: UIButton!
    @IBOutlet weak var approveVw: UIView!
    @IBOutlet weak var blurVw: UIView!
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var mainProjectView: UIView!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var mainProjectButton: UIButton!
    @IBOutlet weak var tasksButton: UIButton!
    @IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var navigationTittle: UINavigationItem!
    
    var pageviewcontroller:UIPageViewController!
    var viewControllers: [BaseViewController] = [BaseViewController]()
    var currentPageIndex:Int = 0
    var nextPageIndex:Int = 0
    var id = 0
    var ongoingtitle = ""
    var completionHandlerGoToOnPastListing: (() -> Void)?
    var callBackToOngoingList: (() -> ())?
    var newProjectsListing: AllProject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.blurVw.isHidden = true
        self.bottomVw.isHidden = false
        self.btnSendMsg.isUserInteractionEnabled = true
        self.btnSendMsg.setTitle("Send Message", for: .normal)
        
        self.lblTop.text = "Project Details" //newProjectsListing?.title ?? ""
        mainProjectView.backgroundColor = UIColor(hex: "#FA9365")
        taskView.backgroundColor = UIColor(hex: "#E8E8E8")
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        bottomVw.addCustomShadow()
        
        self.pageviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "PageViewControllerLeader") as? UIPageViewController
//        self.pageviewcontroller.dataSource = self
//        self.pageviewcontroller.delegate = self
        
        
        if let newControllers = Controllers.mainProjectHO{
            newControllers.newProjectsListing = newProjectsListing
            newControllers.id = id
            self.title = ongoingtitle
            viewControllers.append(newControllers)
        }
        if let newControllers = Controllers.taskHO{
            newControllers.id = id
            viewControllers.append(newControllers)
        }
        if let firstViewController = viewControllers.first {
            self.pageviewcontroller.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        
        self.viewContainer.addSubview(pageviewcontroller.view)
        self.pageviewcontroller.view.frame = CGRect(x: 0, y: 0, width: self.viewContainer.frame.width, height: self.viewContainer.frame.height)
        self.addChild(pageviewcontroller)
        self.pageviewcontroller.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        mainProjectView.backgroundColor = UIColor(hex: "#FA9365")
        taskView.backgroundColor = UIColor(hex: "#E8E8E8")
        mainProjectButton.setTitleColor(UIColor.black, for: .normal)
        tasksButton.setTitleColor(UIColor.gray, for: .normal)
        
        if let newControllers = Controllers.mainProjectHO{
            newControllers.newProjectsListing = newProjectsListing
            newControllers.id = id
            self.title = ongoingtitle
            viewControllers.append(newControllers)
        }
        if let newControllers = Controllers.taskHO{
            newControllers.id = id
            viewControllers.append(newControllers)
        }
        if let firstViewController = viewControllers.first {
            self.pageviewcontroller.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        nextPageIndex = 0
        currentPageIndex = 0
        selectedChoice()
        NotificationCenter.default.addObserver(self, selector: #selector(self.approveDeliveryCheck(notification:)), name: Notification.Name("ApproveDeliveryCheck"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.disApproveDeliveryCheck(notification:)), name: Notification.Name("DisApproveDeliveryCheck"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.adminAprovalCheck(notification:)), name: Notification.Name("AdminAprovalCheck"), object: nil)
    }
    
    @objc func adminAprovalCheck(notification: Notification) {
        self.blurVw.isHidden = true
        self.approveVw.isHidden = true
        self.bottomVw.isHidden = false
        self.btnSendMsg.isUserInteractionEnabled = false
        self.btnSendMsg.setTitle("Awaiting Admin Approval", for: .normal)
        self.btnSendMsg.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc func approveDeliveryCheck(notification: Notification) {
        self.blurVw.isHidden = true
        self.approveVw.isHidden = false
        self.bottomVw.isHidden = false
        self.btnSendMsg.isUserInteractionEnabled = true
        self.btnSendMsg.setTitle("Send Message", for: .normal)
    }

    @objc func disApproveDeliveryCheck(notification: Notification) {
        self.blurVw.isHidden = false
        self.approveVw.isHidden = false
        self.bottomVw.isHidden = false
        self.btnSendMsg.isUserInteractionEnabled = true
        self.btnSendMsg.setTitle("Send Message", for: .normal)
    }

    
    @IBAction func tapDidBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessageBtnAction(_ sender: Any) {
        var id = self.newProjectsListing?.contractorProject?[0].contractorDetails?.id
        let user_id = String("ID_\(id ?? 0)")
        var firstName = self.newProjectsListing?.contractorProject?[0].contractorDetails?.firstName ?? ""
        var lastName = self.newProjectsListing?.contractorProject?[0].contractorDetails?.lastName ?? ""
        let user_name = (firstName + " " + lastName)
        let user_img = self.newProjectsListing?.contractorProject?[0].contractorDetails?.profilePic
        openChatWindow(user_id: user_id, user_image: user_img, user_name: user_name )
    }
    
    func openChatWindow(user_id: String?, user_image: String?, user_name: String?) {
        DispatchQueue.main.async {
            if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
                chatController.hidesBottomBarWhenPushed = true
                chatController.viewModel.user_id = user_id
                chatController.viewModel.user_name = user_name
                chatController.viewModel.user_image = user_image
                self.navigationController?.pushViewController(chatController, animated: true)
            }
        }
    }
    //MARK:- SELECTED CHOICE
    func selectedChoice() {
        if currentPageIndex == 0 {
            mainProjectView.backgroundColor = UIColor(hex: "#FA9365")
            taskView.backgroundColor = UIColor(hex: "#E8E8E8")
            mainProjectButton.setTitleColor(UIColor.black, for: .normal)
            tasksButton.setTitleColor(UIColor.gray, for: .normal)
           
        } else if currentPageIndex == 1 {
            taskView.backgroundColor = UIColor(hex: "#FA9365")
            mainProjectView.backgroundColor = UIColor(hex: "#E8E8E8")
            tasksButton.setTitleColor(UIColor.black, for: .normal)
            mainProjectButton.setTitleColor(UIColor.gray, for: .normal)
          
        } else if currentPageIndex == 2 {
            
            mainProjectView.backgroundColor = UIColor(hex: "#E8E8E8")
            taskView.backgroundColor = UIColor(hex: "#E8E8E8")
            mainProjectButton.setTitleColor(UIColor.gray, for: .normal)
            tasksButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    @IBAction func tapDidMainProjectButton(_ sender: UIButton) {
        if let firstViewController = viewControllers.first{
            mainProjectView.backgroundColor = UIColor(hex: "#FA9365")
            taskView.backgroundColor = UIColor(hex: "#E8E8E8")
            mainProjectButton.setTitleColor(UIColor.black, for: .normal)
            tasksButton.setTitleColor(UIColor.gray, for: .normal)
            self.currentPageIndex = 0
            self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
        }
    }
    
    @IBAction func tapDidTasksButton(_ sender: UIButton) {
        let firstViewController = viewControllers[1]
        taskView.backgroundColor = UIColor(hex: "#FA9365")
        mainProjectView.backgroundColor = UIColor(hex: "#E8E8E8")
        tasksButton.setTitleColor(UIColor.black, for: .normal)
        mainProjectButton.setTitleColor(UIColor.gray, for: .normal)
        self.currentPageIndex = 1
        self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
    }
    
    @IBAction func approveDeliveryButtonAction(_ sender: Any) {
        let destinationViewController = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "ConfirmVC") as? ConfirmVC
        destinationViewController!.projectId = id
//        destinationViewController!.completionHandlerGoToOngoingProjectList = { [weak self] in
//            self!.navigationController?.popViewController(animated: true)
//
//        }
        destinationViewController?.callBackToFeedBackScreen = {
            () in
            let vc = Storyboard.feedBackHO.instantiateViewController(withIdentifier: "FeedBackHOVC") as? FeedBackHOVC
            vc!.projectID = self.id
            vc!.contractorID  = self.newProjectsListing?.contractorProject?[0].userID ?? 0
            vc!.firstName = self.newProjectsListing?.contractorProject?[0].contractorDetails?.firstName ?? ""
            vc!.lastNmae = self.newProjectsListing?.contractorProject?[0].contractorDetails?.lastName ?? ""
            vc!.completionHandlerGoToOnPastListing = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.completionHandlerGoToOnPastListing?()
            }
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        destinationViewController?.callBackToReject = {
            let destinationViewController = Storyboard.newHO.instantiateViewController(withIdentifier: "RejectBidVC") as? RejectBidVC
            destinationViewController?.isFrom = "OngoingHo"
            destinationViewController?.projectId = self.id
            destinationViewController?.completionHandlerGoToViewBids = {
                self.navigationController?.popViewController(animated: true)
                self.callBackToOngoingList?()
            }
            self.present(destinationViewController!, animated: true, completion: nil)
        }
    
//        destinationViewController!.completionHandlerGoToOngoingProjectList = { [weak self] in
//            let vc = Storyboard.feedBackHO.instantiateViewController(withIdentifier: "FeedBackHOVC")
//            self!.navigationController?.pushViewController(vc, animated: true)
//        }
        destinationViewController!.isFrom = "OngoingDetail"
        self.present(destinationViewController!, animated: true, completion: nil)
    }
}


extension OngoingDetailHOVC:UIPageViewControllerDelegate{

}

extension OngoingDetailHOVC:UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController as! BaseViewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard viewControllers.count > previousIndex else {
            return nil
        }
        return viewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController as! BaseViewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let ViewControllersCount = viewControllers.count

        guard ViewControllersCount != nextIndex else {
            return nil
        }

        guard ViewControllersCount > nextIndex else {
            return nil
        }
        return viewControllers[nextIndex]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let pageItemController = pendingViewControllers[0] as? BaseViewController {
            currentPageIndex = pageItemController.index
            pageItemController.printFrame()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        }
        print(pageViewController.viewControllers?.first)
        if pageViewController.viewControllers?.first == viewControllers[1]{
            nextPageIndex = 1
        }
//        else if (pageViewController.viewControllers?.first) == viewControllers[2]{
//            nextPageIndex = 2
//        }
        else if (pageViewController.viewControllers?.first) == viewControllers[0]{
            nextPageIndex = 0
        }
        currentPageIndex = nextPageIndex
        print("-----------\(currentPageIndex)")
        self.selectedChoice()
    }
}
