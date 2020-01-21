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
let pageSize: NSInteger = 10;

class ListVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, LayoutDelegate {
    
    @IBOutlet weak var collection: UICollectionView?
    @IBOutlet weak var pageControl: UIPageControl?
    var has_more = true;
    var dataRefreshing = false;
    var users: [User] = [] {
        didSet {
            DispatchQueue.main.async {
                if let pageControl = self.pageControl {
                    if (self.users.count > pageSize * pageControl.numberOfPages) {
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
        redrawCollection()
    }

    func redrawCollection() {
        self.prepareCellSizes()
        self.showLayout()
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
        return  (pageSize < users.count ? pageSize : users.count)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
        let index = self.pageControl!.currentPage*pageSize+section;
        let user = users[index]
        let items = user.items ?? []
        return items.count;
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader{
            let index = self.pageControl!.currentPage*pageSize+indexPath.section;
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
        let index = self.pageControl!.currentPage*pageSize+indexPath.section;
        let user = users[index]
        let items = user.items ?? []
        let imgUrl = URL(string: items[indexPath.row] )
        // cell.imageView.kf.setImage(with: imgUrl)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == collectionView.numberOfSections-1 {
            print ("add data")
            // refreshData()
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
