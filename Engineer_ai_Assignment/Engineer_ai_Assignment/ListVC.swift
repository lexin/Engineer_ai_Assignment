//
//  ListVC.swift
//  Engineer_ai_Assignment
//
//  Created by Alexey Romanko on 13.01.2020.
//  Copyright © 2020 Romanko. All rights reserved.
//

import UIKit
import Kingfisher

let gap: CGFloat = 10;
let pageSize: NSInteger = 10;

class ListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collection: UICollectionView?
    @IBOutlet weak var pageControl: UIPageControl?
    var has_more = true;
    var dataRefreshing = false;
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                if let pageControl = self.pageControl {
                    if (self.users.count >= pageSize * pageControl.numberOfPages) {
                        let pageNumb = self.users.count/pageSize;
                        pageControl.numberOfPages = pageNumb;
                        pageControl.isHidden = (pageControl.numberOfPages > 0) ? false : true
                        pageControl.currentPage = pageNumb-1;
                    }
                }
                self.redrawCollection()
            }
        }
    }

    var refreshControl : UIRefreshControl? = nil;
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl?.currentPage = 0;
        pageControl?.numberOfPages = 1;
        pageControl?.isHidden = true;

        refreshData()

        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl?.triggerVerticalOffset = 50.0
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collection?.bottomRefreshControl = refreshControl
    }

    @IBAction func pageControlValueChanged(_ sender: Any) {
        collection?.scrollToItem(at: IndexPath(row: 0, section: pageControl!.currentPage*pageSize), at: .top, animated: true)
    }

    func redrawCollection() {
        //self.prepareCellSizes()
        collection?.reloadData()
    }
    @objc func refreshData() {
        if (pageControl!.numberOfPages == pageControl!.currentPage + 1) {
            if (has_more) {
                if (self.dataRefreshing==false) {
                    self.dataRefreshing = true
                    DataService.sh.getUsers(offset: self.users.count, limit: pageSize, completion: { (object) in

                        DispatchQueue.main.async {
                            self.refreshControl?.endRefreshing()
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.dataRefreshing = false
                        }

                        guard let answerData = object?.data else {
                            print("Something wrong")
                            return
                        }

                        self.users.append(contentsOf: answerData.users)
                        self.has_more = answerData.has_more
                    }) { (errorText) in
                    }
                }
            } else {
                self.refreshControl?.endRefreshing()
                print("All data is here")
            }
        } else {
            self.refreshControl?.endRefreshing()
            pageControl!.currentPage = pageControl!.currentPage + 1
            redrawCollection()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        let index = section;
        let user = users[index]
        let items = user.items ?? []
        return items.count;

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader{
            let index = indexPath.section;//self.pageControl!.currentPage*pageSize+indexPath.section;
            let user = users[index]
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
        let index = indexPath.section
        let user = users[index]
        let items = user.items ?? []
        let imgUrl = URL(string: items[indexPath.row] )
         cell.imageView.kf.setImage(with: imgUrl)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == collectionView.numberOfSections-1 {
            print ("add data")
            // refreshData()
        }
    }

    private var cellSizes = [[CGSize]]()

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

    func cellSize(indexPath: IndexPath) -> CGSize {
        let s = indexPath.section;
        let r = indexPath.row;
        let sizeValue = cellSizes[s][r]
        return sizeValue
    }

    func headerHeight(indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      }

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          //return cellSize(indexPath: indexPath)
        return CGSize(width: 100, height: 100)
      }

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 10
      }
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 10
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
