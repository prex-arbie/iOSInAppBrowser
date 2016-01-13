//
//  ViewController.swift
//  iOSInAppBrowser
//
//  Created by Arbie on 2016/01/08.
//  Copyright © 2016年 prex-arbie. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var adrArray:[String]?
    var tableArray: [String]?
    var bukkenArray: [String]? = []
    
    var 中文 = "中文的變數"
    
    let allBukkenArray: [String] = ["物件1", "物件2", "物件3", "物件4", "物件5", "物件6", "物件7", "物件8", "物件9", "物件10", "物件11", "物件12", "物件13", "物件14", "物件15", "物件16", "物件17", "物件18", "物件19", "物件20"]
    
    @IBOutlet weak var moveableTableView: UITableView!
    @IBOutlet weak var moveableWebView: UIWebView!
    @IBOutlet weak var switchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(中文)
        
        tableArray = self.loadTableCell("1")
        print(tableArray)
        adrArray = ["etc/policy", "etc/privacy", "etc/company", "etc/app"]
        
        moveableTableView.hidden = true
        moveableWebView.hidden = true
        
        isWebViewOpened()

        // Delegate設定
        moveableTableView.delegate = self
        moveableTableView.dataSource = self
        moveableWebView.delegate = self
        
        let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let rect: CGRect = CGRect(x: 0, y: statusBarHeight, width: self.view.frame.maxX, height: self.view.frame.maxY - statusBarHeight - switchButton.frame.size.height)
        
        moveableTableView.frame = rect
        moveableWebView.frame = rect
        moveableWebView.scalesPageToFit = true
        self.view.addSubview(moveableTableView)
        self.view.addSubview(moveableWebView)
        
        // App Transport Security SettingsとAllow Arbitrary Loads指定追加が必要。
        let url: NSURL = NSURL(string: "http://ietuna.jp/")!
        let request: NSURLRequest = NSURLRequest(URL: url)
        moveableWebView.loadRequest(request)
    }
    
    // ロード時にインジケータをまわす
    func webViewDidStartLoad(webView: UIWebView) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    // ロード完了でインジケータ非表示
    func webViewDidFinishLoad(webView: UIWebView) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func loadTableCell(myId:String) -> Array<String> {
        
        let choose = Int(arc4random_uniform(UInt32(self.allBukkenArray.count - 1)))
        
        self.bukkenArray = []
        
        for var i = 0; i <= choose; i++ {
            self.bukkenArray?.append(self.allBukkenArray[i])
        }
        
        if self.bukkenArray!.isEmpty {
            self.bukkenArray = ["物件がありません"]
        }
        let myBukkenArray = self.bukkenArray
        
        return myBukkenArray!
    }
    
    func isWebViewOpened() {
        
        if moveableWebView.hidden {
            switchButton.setTitle("On", forState: UIControlState.Normal)
        }else{
            switchButton.setTitle("Off", forState: UIControlState.Normal)
        }
    }
    
    
    
    @IBAction func linkButton(sender: AnyObject) {
        
        print("link")
    }
    
    @IBAction func tableButton(sender: AnyObject) {
        
        tableArray = self.loadTableCell("1")
        self.refreshUI()
        
        moveableTableView.hidden = false
        moveableWebView.hidden = true
        
        isWebViewOpened()
        
    }
    
    @IBAction func switchButton(sender: AnyObject) {
        
        if moveableWebView.hidden {
            moveableWebView.hidden = false
        }else{
            moveableWebView.hidden = true
        }
        
        isWebViewOpened()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return false
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshUI() {
        dispatch_async(dispatch_get_main_queue(), {
            self.moveableTableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.tableArray?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.tableArray?[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You've selected cell #\(indexPath.row)")
        
        let key = Int(arc4random_uniform(4))
        let url: NSURL = NSURL(string: "http://ietuna.jp/\(adrArray![key])")!
        print(url)
        let request: NSURLRequest = NSURLRequest(URL: url)
        moveableWebView.loadRequest(request)
        moveableWebView.hidden = false
        
        isWebViewOpened()
    }
    
}