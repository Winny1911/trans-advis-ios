//
//  SubTaskVC.swift
//  TA
//
//  Created by Designer on 13/12/21.
//

import UIKit

class SubTaskProjectVC: BaseViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var subTaskButton: UIButton!
    @IBOutlet weak var orderListButton: UIButton!
    
    @IBOutlet weak var subTaskView: UIView!
    @IBOutlet weak var orderListView: UIView!
    
   // @IBOutlet weak var bottomVw: UIView!
    var pageviewcontroller:UIPageViewController!
    var viewControllers: [BaseViewController] = [BaseViewController]()
    
    var currentPageIndex:Int = 0
    var nextPageIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        self.pageviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "PageViewControllerLeader") as? UIPageViewController
        self.pageviewcontroller.dataSource = self
        self.pageviewcontroller.delegate = self

        viewControllers.append(Controllers.subTask!)
        viewControllers.append(Controllers.subTaskOrderList!)
        
        
        
        

        if let firstViewController = viewControllers.first {
             self.pageviewcontroller.setViewControllers([firstViewController],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }

        self.viewContainer.addSubview(pageviewcontroller.view)
        self.pageviewcontroller.view.frame = CGRect(x: 0, y: 0, width: self.viewContainer.frame.width, height: self.viewContainer.frame.height)

        self.addChild(pageviewcontroller)
        //self.view.addSubview(pageviewcontroller.view)
        self.pageviewcontroller.didMove(toParent: self)
        
        
        subTaskView.backgroundColor = UIColor(hex: "##4EC72A")
        orderListView.backgroundColor = UIColor(hex: "#E8E8E8")
        
        subTaskButton.setTitleColor(UIColor.black, for: .normal)
        orderListButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    @IBAction func tapDidSubTaskButton(_ sender: UIButton) {
        if let firstViewController = viewControllers.first{
            subTaskView.backgroundColor = UIColor(hex: "##4EC72A")
            orderListView.backgroundColor = UIColor(hex: "#E8E8E8")
            
            subTaskButton.setTitleColor(UIColor.black, for: .normal)
            orderListButton.setTitleColor(UIColor.gray, for: .normal)
            
            self.currentPageIndex = 0
            self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
        }
    }
    
//    @IBAction func backBtnAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    @IBAction func tapDidOrderListButton(_ sender: UIButton) {
      //  bottomVw.isHidden = true
        let firstViewController = viewControllers[1]
        orderListView.backgroundColor = UIColor(hex: "##4EC72A")
        subTaskView.backgroundColor = UIColor(hex: "#E8E8E8")
        
        orderListButton.setTitleColor(UIColor.black, for: .normal)
        subTaskButton.setTitleColor(UIColor.gray, for: .normal)
            self.currentPageIndex = 1
            self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
    }
    
    //MARK:- SELECTED CHOICE
    func selectedChoice() {
        if currentPageIndex == 0 {
            subTaskView.backgroundColor = UIColor(hex: "##4EC72A")
            orderListView.backgroundColor = UIColor(hex: "#E8E8E8")
            
            subTaskButton.setTitleColor(UIColor.black, for: .normal)
            orderListButton.setTitleColor(UIColor.gray, for: .normal)
        } else if currentPageIndex == 1 {
            orderListView.backgroundColor = UIColor(hex: "##4EC72A")
            subTaskView.backgroundColor = UIColor(hex: "#E8E8E8")
            
            orderListButton.setTitleColor(UIColor.black, for: .normal)
            subTaskButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SubTaskProjectVC:UIPageViewControllerDelegate{

}

extension SubTaskProjectVC:UIPageViewControllerDataSource{
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
        else if (pageViewController.viewControllers?.first) == viewControllers[0]{
            nextPageIndex = 0
        }
        currentPageIndex = nextPageIndex
        print("-----------\(currentPageIndex)")
        self.selectedChoice()
    }
}
