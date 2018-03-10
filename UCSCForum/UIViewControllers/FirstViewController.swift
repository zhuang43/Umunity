//
//  FirstViewController.swift
//  UCSCForum
//
//  Created by MacDouble on 1/20/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import Foundation

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var table: UITableView!
    
    var selected: Int = 0
    var selectedItem: Node?
    var itemCount: Int = 0
    var list = LinkedList()
    
    public class Node {
        private var posterName: String
        private var itemAddress: String
        private var itemCategory: String
        private var itemDelivery: Bool
        private var itemDetail: String
        private var itemName: String
        private var itemKey: String
        private var commentCount: Int
        weak var prev: Node? = nil
        var next: Node? = nil
        
        public init() {
            self.posterName = ""
            self.itemAddress = ""
            self.itemCategory = ""
            self.itemDelivery = false
            self.itemDetail = ""
            self.itemName = ""
            self.itemKey = ""
            self.commentCount = 0
        }
        
        public var getPoster: String {
            return self.posterName
        }
        
        public var getAddress: String {
            return self.itemAddress
        }
        
        public var getCategory: String {
            return self.itemCategory
        }
        
        public var getDelivery: Bool {
            return self.itemDelivery
        }
        
        public var getDetail: String {
            return self.itemDetail
        }
        
        public var getName: String {
            return self.itemName
        }
        
        public var getKey: String {
            return self.itemKey
        }
        
        public var getCommentCount : Int {
            return self.commentCount
        }
        
        public func setPoster(person: String){
            self.posterName = person
        }
        
        public func setAddress(address: String){
            self.itemAddress = address
        }
        
        public func setCategory(category: String){
            self.itemCategory = category
        }
        
        public func setDelivery(delivery: Bool){
            self.itemDelivery = delivery
        }
        
        public func setDetail(detail: String){
            self.itemDetail = detail
        }
        
        public func setName(name: String){
            self.itemName = name
        }
        
        public func setKey(key: String){
            self.itemKey = key
        }
        
        public func addCommentCount() {
            self.commentCount = self.commentCount + 1
        }
        
    }
    
    public class LinkedList {
        fileprivate var head: Node?
        private var tail: Node?
        private var cur: Node?
        private var count: Int? = 0
        
        public var isEmpty: Bool {
            return head == nil
        }
        
        public var first: Node? {
            return head
        }
        
        public var last: Node? {
            return tail
        }
        
        public var current: Node? {
            return cur
        }
        
        public var counter: Int? {
            return count
        }
        
        public func append(node: Node) {
            count = count! + 1
            if let tailNode = tail {
                node.prev = tailNode
                tailNode.next = node
            }
            else {
                head = node
            }
            tail = node
        }
        
        public func delete(node: Node) {
            count = count! - 1
            let prev = node.prev
            let next = node.next
            
            if let prev = prev {
                prev.next = next
            } else {
                head = next
            }
            next?.prev = prev
            
            node.prev = nil
            node.next = nil
        }
        
        
        public func printList() {
            var iterator = first
            while iterator != nil {
                print(iterator!.getPoster)
                print(iterator!.getName)
                print(iterator!.getAddress)
                print(iterator!.getCategory)
                print(iterator!.getDelivery)
                print(iterator!.getDetail)
                print(iterator!.getKey)
                
                iterator = iterator?.next
            }
        }
        
        public func clearList() {
            head = nil
            tail = nil
            count = 0
        }
        
        public func getCount() -> Int? {
            var iterator = first
            var itemCount: Int = 0
            while iterator != nil {
                itemCount += 1
                iterator = iterator?.next
            }
            return itemCount
        }
    }
    
    // sends item key of item pressed to comments page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data: String?
        
        var itemIndex = 0
        var itemNode: Node = list.first!
        while(itemIndex < selected){
            itemIndex += 1
            itemNode = itemNode.next!
        }
        data = itemNode.getKey
        
        print("the name in prepare print is \(selectedItem?.getName)")
        
        if let commentViewController = segue.destination as? CommentViewController {
            commentViewController.data = data
        }
        
        if let detailTableViewController = segue.destination as? DetailTableViewController {
            detailTableViewController.dataNode = selectedItem
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cell structure

        let itemCell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        var currentItem = list.first
        
        var i = 0
        
        while i < indexPath.row {
            currentItem = currentItem?.next
            i += 1
        }
        
        itemCell.personName.text = currentItem?.getPoster
        
        itemCell.itemNameTextField.text = currentItem?.getName
        
        itemCell.itemDetailTextField.text = currentItem?.getDetail
        
        itemCell.layer.borderWidth = 9
        itemCell.layer.borderColor = UIColor.clear.cgColor
        itemCell.layer.cornerRadius = 7
        
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Number of cells
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selected = indexPath.row
        var currentItem = list.first
        
        var i = 0
        
        while i < indexPath.row {
            currentItem = currentItem?.next
            i += 1
        }
        
        print("name in didSelectRowAt is \(String(describing: currentItem?.getName))")
        selectedItem = currentItem
        UserDefaults.standard.set(currentItem?.getName, forKey: "selectedNodeName")
        //UserDefaults.standard.set(currentItem, forKey: "selectedNode")
        
        print("row: \(indexPath.row)")
        
        performSegue(withIdentifier: "DetailSegue", sender: FirstViewController())
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let itemCell = tableView.cellForRow(at: indexPath) as! ItemTableViewCell
        
        let itemNameObject = UserDefaults.standard.object(forKey: "itemName")
        
        let itemDetailObject = UserDefaults.standard.object(forKey: "itemDetail")
        
        print (itemCell.itemDetailTextField.text!)
        
        print (itemCell.itemNameTextField.text!)
        
        if var itemName = itemNameObject as? [String] {
            
            itemName.remove(at: indexPath.row)
            UserDefaults.standard.set(itemName, forKey: "itemName")
            
        }
        
        if var itemDetail = itemDetailObject as? [String] {
            
            itemDetail.remove(at: indexPath.row)
            UserDefaults.standard.set(itemDetail, forKey: "itemDetail")
            
        }
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference().child("market").child(itemCell.itemNameTextField.text!)
        
        ref.removeValue()
        
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector((reloadTable)), userInfo: nil, repeats: false)
        
    }

    
    @IBAction func sendToDatabase(_ sender: Any) {
        reloadTable()
        table.reloadData()
    }
    
    @objc public func reloadTable() {
        var ref: DatabaseReference!
        ref = Database.database().reference().child("market")
        
        
        
        ref.observeSingleEvent(of: .value, with: {
            (snapshot) in
            self.list.clearList()
            for child in snapshot.children {
                let node = Node()
                let keysnap = child as! DataSnapshot
                node.setKey(key: keysnap.key)
                for grandchild in (child as AnyObject).children {
                    let snap = grandchild as! DataSnapshot
                    let key = snap.key
                    let value = snap.value
                    switch key {
                    case "posterName":
                        node.setPoster(person: value! as! String)
                    case "itemName":
                        node.setName(name: value! as! String)
                    case "itemAddress":
                        node.setAddress(address: value! as! String)
                    case "itemCategory":
                        node.setCategory(category: value! as! String)
                    case "itemDelivery":
                        node.setDelivery(delivery: value! as! Bool)
                    case "comments":
                        for _ in (grandchild as
                            AnyObject).children{
                                node.addCommentCount()
                        }
                        print("do nothing")
                    default:
                        node.setDetail(detail: value! as! String)
                    }
                }
                print("\(node.getName) has \(node.getCommentCount) comments.")
                self.list.append(node: node)
            }
            
            self.itemCount = self.list.getCount()!
            
            self.list.printList()
        })
        table.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadTable()
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector((reloadTable)), userInfo: nil, repeats: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector((reloadTable)), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view, typically from a nib.
        tableView.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 216
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

