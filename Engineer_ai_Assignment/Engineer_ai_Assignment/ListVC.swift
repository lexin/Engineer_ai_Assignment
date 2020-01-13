//
//  ListVC.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 13.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//

import UIKit

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }

     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        return section == 0 ? CGFloat.leastNonzeroMagnitude : 32
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = self.table.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.textLabel?.text = "\(indexPath.row + 1)"
        return cell
    }
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
