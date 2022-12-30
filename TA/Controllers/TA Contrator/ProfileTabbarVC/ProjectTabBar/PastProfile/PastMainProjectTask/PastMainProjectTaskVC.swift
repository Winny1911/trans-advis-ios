//
//  PastMainProjectTaskVC.swift
//  TA
//
//  Created by Designer on 14/12/21.
//

import UIKit

class PastMainProjectTaskVC: BaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var mainProjectView: UIView!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var orderlistView: UIView!
    @IBOutlet weak var mainProjectButton: UIButton!
    @IBOutlet weak var tasksButton: UIButton!
    @IBOutlet weak var orderlistButton: UIButton!
    
    
    var pageviewcontroller:UIPageViewController!
    var viewControllers: [BaseViewController] = [BaseViewController]()
    
    var currentPageIndex:Int = 0
    var nextPageIndex:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        mainProjectView.backgroundColor = UIColor(hex: "#FA9365")
        taskView.backgroundColor = UIColor(hex: "#E8E8E8")
        orderlistView.backgroundColor = UIColor(hex: "#E8E8E8")
        
        tabBarController?.tabBar.isHidden = true
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 5.0
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowOffset = CGSize.zero
        
        self.pageviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "PageViewControllerLeader") as? UIPageViewController
        self.pageviewcontroller.dataSource = self
        self.pageviewcontroller.delegate = self

        if let newControllers = Controllers.pastMainProject{
            viewControllers.append(newControllers)
        }
        if let newControllers = Controllers.pastTasks{
            viewControllers.append(newControllers)
        }
        if let newControllers = Controllers.pastOrderlist{
            viewControllers.append(newControllers)
        }
//        viewControllers.append(Controllers.pastMainProject!)
//        viewControllers.append(Controllers.pastTasks!)
//        viewControllers.append(Controllers.pastOrderlist!)
        
//        viewControllers.append(UIStoryboard(name: "PastMainProject", bundle: nil).instantiateViewController(withIdentifier: "PastMainProjectVC") as! BaseViewController)
//        viewControllers.append(UIStoryboard(name: "PastTasks", bundle: nil).instantiateViewController(withIdentifier: "PastTasksVC") as! BaseViewController)
//        viewControllers.append(UIStoryboard(name: "PastOrderlist", bundle: nil).instantiateViewController(withIdentifier: "PastOrderlistVC") as! BaseViewController)

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mainProjectView.backgroundColor = UIColor(hex: "#FA9365")
        taskView.backgroundColor = UIColor(hex: "#E8E8E8")
        orderlistView.backgroundColor = UIColor(hex: "#E8E8E8")
        mainProjectButton.setTitleColor(UIColor.black, for: .normal)
        tasksButton.setTitleColor(UIColor.gray, for: .normal)
        orderlistButton.setTitleColor(UIColor.gray, for: .normal)
        
        if let firstViewController = viewControllers.first {
             self.pageviewcontroller.setViewControllers([firstViewController],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
        nextPageIndex = 0
        currentPageIndex = 0
        selectedChoice()
    }
    
    
    @IBAction func tapDidBackButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- SELECTED CHOICE
    func selectedChoice() {
        if currentPageIndex == 0 {
            mainProjectView.backgroundColor = UIColor(hex: "#FA9365")
            taskView.backgroundColor = UIColor(hex: "#E8E8E8")
            orderlistView.backgroundColor = UIColor(hex: "#E8E8E8")
            
            mainProjectButton.setTitleColor(UIColor.black, for: .normal)
            tasksButton.setTitleColor(UIColor.gray, for: .normal)
            orderlistButton.setTitleColor(UIColor.gray, for: .normal)
        } else if currentPageIndex == 1 {
            taskView.backgroundColor = UIColor(hex: "#FA9365")
            mainProjectView.backgroundColor = UIColor(hex: "#E8E8E8")
            orderlistView.backgroundColor = UIColor(hex: "#E8E8E8")
            
            tasksButton.setTitleColor(UIColor.black, for: .normal)
            mainProjectButton.setTitleColor(UIColor.gray, for: .normal)
            orderlistButton.setTitleColor(UIColor.gray, for: .normal)
        } else if currentPageIndex == 2 {
            orderlistView.backgroundColor = UIColor(hex: "#FA9365")
            mainProjectView.backgroundColor = UIColor(hex: "#E8E8E8")
            taskView.backgroundColor = UIColor(hex: "#E8E8E8")
            
            orderlistButton.setTitleColor(UIColor.black, for: .normal)
            mainProjectButton.setTitleColor(UIColor.gray, for: .normal)
            tasksButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    @IBAction func tapDidMainProjectButton(_ sender: UIButton) {
        if let firstViewController = viewControllers.first{
            mainProjectView.backgroundColor = UIColor(hex: "#FA9365")
            taskView.backgroundColor = UIColor(hex: "#E8E8E8")
            orderlistView.backgroundColor = UIColor(hex: "#E8E8E8")
            mainProjectButton.setTitleColor(UIColor.black, for: .normal)
            tasksButton.setTitleColor(UIColor.gray, for: .normal)
            orderlistButton.setTitleColor(UIColor.gray, for: .normal)
            self.currentPageIndex = 0
            self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
        }
    }
    
    @IBAction func tapDidTasksButton(_ sender: UIButton) {
        let firstViewController = viewControllers[1]
        taskView.backgroundColor = UIColor(hex: "#FA9365")
        mainProjectView.backgroundColor = UIColor(hex: "#E8E8E8")
        orderlistView.backgroundColor = UIColor(hex: "#E8E8E8")
        
        tasksButton.setTitleColor(UIColor.black, for: .normal)
        mainProjectButton.setTitleColor(UIColor.gray, for: .normal)
        orderlistButton.setTitleColor(UIColor.gray, for: .normal)
        self.currentPageIndex = 1
        self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
    }
    
    @IBAction func tapDidOrderlistButton(_ sender: UIButton) {
        let firstViewController = viewControllers[2]
        orderlistView.backgroundColor = UIColor(hex: "#FA9365")
        mainProjectView.backgroundColor = UIColor(hex: "#E8E8E8")
        taskView.backgroundColor = UIColor(hex: "#E8E8E8")
        
        orderlistButton.setTitleColor(UIColor.black, for: .normal)
        mainProjectButton.setTitleColor(UIColor.gray, for: .normal)
        tasksButton.setTitleColor(UIColor.gray, for: .normal)
        self.currentPageIndex = 2
        self.pageviewcontroller.setViewControllers([firstViewController],direction: .forward,animated: false,completion: nil)
    }
}

extension PastMainProjectTaskVC: UIPageViewControllerDelegate{

}

extension PastMainProjectTaskVC: UIPageViewControllerDataSource{
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
        else if (pageViewController.viewControllers?.first) == viewControllers[2]{
            nextPageIndex = 2
        }
        else if (pageViewController.viewControllers?.first) == viewControllers[0]{
            nextPageIndex = 0
        }
        currentPageIndex = nextPageIndex
        print("-----------\(currentPageIndex)")
        self.selectedChoice()
    }
}
