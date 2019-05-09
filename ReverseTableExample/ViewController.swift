//
//  ViewController.swift
//  ReverseTableExample
//
//  Created by baottran on 5/8/19.
//  Copyright © 2019 baottran. All rights reserved.
//

import UIKit

struct Item {
    var id: Int
}

class ViewController: UITableViewController {
    
    var currentMax = 0
    var currentMin = 0
    
    var collection = [Item]()
    
    var dataSource: [Item] {
        return collection.reversed()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        load()
        tableView.prefetchDataSource = self
//        tableView.scroll
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let item = dataSource[indexPath.row]
        cell.label.text = "\(item.id)"
        return cell
    }
    
    func load(){
        for _ in 0..<40 {
            collection.append(Item(id: currentMax))
            currentMax += 1
        }
        tableView.reloadData()
        scrollToBottom()
    }
    
    @IBAction func append(){
        for _ in 0..<40 {
            collection.insert(Item(id: currentMin), at: 0)
            currentMin -= 1
        }
        
        tableView.reloadData()
        scrollToBottom()
    }
    
    var loading = false
    
    @IBAction func prepend40(){
        prepend()
    }
    
    func prepend(numAdding: Int = 40){
        
        guard !loading else {
            return
        }
        
        loading = true
    
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
   
            var indexPaths = [IndexPath]()
        
            for i in 0...numAdding {
                self.currentMax += 1
                self.collection.append(Item(id: self.currentMax))
                indexPaths.append(IndexPath(row: i, section: 0))
            }
        
            
            let indexPathToJump: IndexPath
            
            if let visibile = self.tableView.indexPathsForVisibleRows, let ip = visibile.first {
                indexPathToJump = IndexPath(row: ip.row + numAdding + 1, section: 0)
            } else {
                indexPathToJump = IndexPath(row: numAdding + 1, section: 0)
            }
        
            UIView.setAnimationsEnabled(false)
            self.tableView.performBatchUpdates({
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: { _ in
                self.tableView.scrollToRow(at: indexPathToJump, at: .top, animated: false)
                self.loading = false
            })
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func scrollToBottom(){
        tableView.scrollToRow(at: IndexPath(row: collection.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("lol")
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            prepend(numAdding: 5)
        }
    }
    
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        print("prefetchRowsAt \(dataSource[indexPaths.first?.row ?? 0].id)")
    }
}


