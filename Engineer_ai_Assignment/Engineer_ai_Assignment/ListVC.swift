//
//  ListVC.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 13.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//

import UIKit
import Kingfisher
import collection_view_layouts

let gap: CGFloat = 10;
let pageSize: NSInteger = 20;

class ListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, LayoutDelegate {
    
    @IBOutlet weak var collection: UICollectionView?
    var has_more = true;
    var dataRefreshing = false;
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.prepareCellSizes()
                self.showLayout()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }

    func refreshData() {
        if (has_more) {
            if (self.dataRefreshing==false) {
                self.dataRefreshing = true
                DataService.sh.getUsers(offset: self.users.count, limit: pageSize, completion: { (object) in
                    self.dataRefreshing = false
                    guard let answerData = object?.data else {
                        print("Something wrong")
                        return
                    }
                    self.has_more = answerData.has_more
                    self.users.append(contentsOf: answerData.users)
                }) { (errorText) in
                }
            }
        } else {
        	print("All data is here")
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return users.count;
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let user = users[section]
        let items = user.items ?? []
        return items.count;
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

        let cell : CollectionViewCell  = collectionView
            .dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! CollectionViewCell
        let user = users[indexPath.section]
        let items = user.items ?? []
        let imgUrl = URL(string: items[indexPath.row] )
        cell.imageView.kf.setImage(with: imgUrl)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == users.count - 1 {
            print ("add data")
            refreshData()
        }
    }

    private var cellSizes = [[CGSize]]()
    private var layout: BaseLayout!

    private func prepareCellSizes() {
        cellSizes.removeAll()

        for user in users {
            var oneSectionSizes : [CGSize] = []

            if let items = user.items {
                for item in items {

                    //even
                    var width = CGFloat(((collection?.frame.size.width ?? 100)-gap)/2)


                    if (items.count % 2 != 0)  {//odd
                        if (item == items.first) {
							width = CGFloat(collection?.frame.size.width ?? 100)
                        }
                    }

                    let height = width
   					oneSectionSizes.append(CGSize(width: width, height: height))
                }

                }
            cellSizes.append(oneSectionSizes)
        }
    }

    private func showLayout() {

        layout = Px500Layout()
        layout.delegate = self

        // All layouts support this configs
        layout.contentPadding = ItemsPadding(horizontal: 0, vertical: 0)
        layout.cellsPadding = ItemsPadding(horizontal: gap, vertical: gap)

        collection?.collectionViewLayout = layout
        collection?.setContentOffset(CGPoint.zero, animated: false)
        collection?.reloadData()
    }

    func cellSize(indexPath: IndexPath) -> CGSize {
        let s = indexPath.section;
        let r = indexPath.row;
        let sizeValue = cellSizes[s][r]
        return sizeValue
    }

    func headerHeight(indexPath: IndexPath) -> CGFloat {
          return 75
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
