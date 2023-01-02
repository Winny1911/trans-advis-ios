//
//  ArchiveHOVC.swift
//  TA
//
//  Created by Dev on 10/12/21.
//

import UIKit

class ArchiveHOVC: BaseViewController{

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        registerCell()

      }
    
    func registerCell() {
        tableView.register(UINib.init(nibName: "NewHOTableViewCell", bundle: nil), forCellReuseIdentifier: "NewHOTableViewCell")
        }
}

extension ArchiveHOVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewHOTableViewCell", for: indexPath) as! NewHOTableViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
