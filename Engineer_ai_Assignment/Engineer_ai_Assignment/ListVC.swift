//
//  ListVC.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 13.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//

import UIKit
import Kingfisher

class ListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collection: UICollectionView?
    var users: [User] = [] {
        didSet {
             DispatchQueue.main.async {
                self.collection?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }

    func refreshData() {
        DataService.sh.getUsers(offset: 0, limit: 20, completion: { (object) in
            guard let answerData = object?.data else {
                print("Something wrong")
                return
            }
            self.users = answerData.users
        }) { (errorText) in
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return users.count;
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader{
            let user = users[indexPath.section]
            sectionHeader.label.text = "\(user.name ?? "Unknown")"
            let imgUrl = URL(string: user.image ?? "")
            sectionHeader.imageView.kf.setImage(with: imgUrl)
            return sectionHeader
        }
        return UICollectionReusableView()
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCellID = "CollectionCell"

        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath)
        cell.backgroundColor = UIColor.yellow

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
