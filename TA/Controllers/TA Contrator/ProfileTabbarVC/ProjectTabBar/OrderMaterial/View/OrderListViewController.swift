//
//  OrderListViewController.swift
//  TA
//
//  Created by Shikha Pandey on 10/02/22.
//

import UIKit

class OrderListViewController: UIViewController {

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblOrders: UILabel!
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    var viewModel:OrderListViewModel = OrderListViewModel()
    var vendorID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        if let id = vendorID{
            viewModel.vendorId = id
        }
        // Do any additional setup after loading the view.
    }
    
    func registerCells() {
        listCollectionView.register(UINib(nibName: "MaterialCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MaterialCollectionViewCell")
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
    }
    
    

}

extension OrderListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = listCollectionView.dequeueReusableCell(withReuseIdentifier: "MaterialCollectionViewCell", for: indexPath) as! MaterialCollectionViewCell
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (listCollectionView.frame.size.width/2) - 5, height: listCollectionView.frame.size.height/3.4)
    }
    
}
