//
//  ViewController.swift
//  ios-webApp
//
//  Created by HelloMac on 16/6/27.
//  Copyright © 2016年 HelloMac. All rights reserved.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController,UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var webView:UIWebView?
    
    var image:String = String();
    var width:Float = Float();
    var height:Float = Float();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createWebView();
    }

    func createWebView() {
        webView = UIWebView.init(frame: CGRectMake(0, 64, (UIScreen.mainScreen().bounds.width),(UIScreen.mainScreen().bounds.height)));
        webView?.userInteractionEnabled = true;
        webView?.delegate = self;
        self.view.addSubview(webView!);
        
        //加载本地文本资源
       // let url = NSURL.fileURLWithPath("/Users/van/Desktop/ios-webApp/ios-webApp/js端.html");
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("js端", ofType: "html")!);
        let request = NSURLRequest.init(URL: url);
        webView?.loadRequest(request);
        
        let context:JSContext = (self.webView?.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext"))! as! JSContext;
        let jakilllog:@convention(block) Void -> Void = {Void in
        
            self.albumCollection();
        }
        context.setObject(unsafeBitCast(jakilllog, AnyObject.self), forKeyedSubscript: "jakilllog");
    }
    
    func albumCollection() {
        let pickerControll = UIImagePickerController();
        pickerControll.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        pickerControll.delegate = self;
        self.presentViewController(pickerControll, animated: true, completion: nil);
    }
    
    /**
        pickerControll代理方法
     */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
        let imageUrl = info[UIImagePickerControllerReferenceURL];
        let strString = imageUrl?.absoluteString;
        let imageName = strString?.componentsSeparatedByString("?")[1];
        
        let str = self.saveImage(image, imageName: imageName!);
        self.image = str;
        self.width = (Float)(image.size.width);
        self.height = (Float)(image.size.height);
        
        //调用js函数时，参数传不过去
        //坑啊(⊙o⊙)  不能使用oc中的方法，要使用单引号‘’,\()传入数值，不能直接加入字符串中，那样不能得到正确的数值
        let context:JSContext = (self.webView?.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext"))! as! JSContext;
       
        
        print("\(self.height)  \(self.width)   \(self.image)");
        context.evaluateScript("log('\(self.height)','\(self.width)','\(self.image)')");
        
        picker.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func saveImage(image:UIImage ,imageName:String) -> String {
        let fileManager = NSFileManager.defaultManager();
        let data = UIImageJPEGRepresentation(image, 1);
        let DocumentPath = NSHomeDirectory().stringByAppendingString("/Documents");
        
        do{
            try fileManager.createDirectoryAtPath(DocumentPath, withIntermediateDirectories: true, attributes: nil);}
        catch{
        
        }
        
    fileManager.createFileAtPath(DocumentPath.stringByAppendingString("/"+imageName), contents: data, attributes: nil);
        
        let fullPath = DocumentPath.stringByAppendingString("/"+imageName);

        return fullPath;
    }
    
    /**
        webView代理方法
     */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true;
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        //开始加载
        
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        //结束加载
       
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

