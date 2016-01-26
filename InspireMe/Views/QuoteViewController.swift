//
//  QuoteViewController.swift
//  InpireMe
//
//  Created by Dante Solorio on 11/27/15.
//  Copyright © 2015 Zahui Software. All rights reserved.
//

import UIKit
import Parse
import SWActivityIndicatorView
import iAd

class QuoteViewController: UIViewController, ADBannerViewDelegate{
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bannerViewOutlet: ADBannerView!
    
    @IBOutlet weak var activityIndicatorView: SWActivityIndicatorView!
    
    var quotesObjArray: [Quote] = []
    var numbersQuotesArray: NSMutableArray = []
    
    //var bannerView: ADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupiAd()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func nextQuote(sender:AnyObject){
        activityIndicatorView.startAnimating()
        getRandomQuote()
    }
    
    
    // MARK: General Functions
    
    func getRandomQuote(){
        let language = getCurrentLanguage()
        PFCloud.callFunctionInBackground("getRandomQuote", withParameters: ["lang":language]) {
            (response: AnyObject?, error: NSError?) -> Void in
            
            if (error == nil){
                let quote = response!["quote"] as! String
                let author = response!["author"] as! String
                self.updateQuoteLabel(quote, author: author)
                self.activityIndicatorView.stopAnimating()
            }else{
                self.showErrorMessage(error!)
                //print("Error \(error)")
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func updateQuoteLabel(quote: String, author: String){
        self.quoteLabel.text = quote
        self.authorLabel.text = author
    }
    
    func showErrorMessage(error: AnyObject){
        let errorCode = error as! NSError
        print("Error code \(errorCode.code)")
        print("Error \(error)")
        
        let alertView = UIAlertController(title: "Error", message: "Please verify your internet connection", preferredStyle: UIAlertControllerStyle.Alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alertView.addAction(okAlertAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    func setupView(){
        self.backgroundImageView.image =  UIImage(named: "background.jpg")
        
        self.authorLabel.text = String(NSLocalizedString("Thomas Edison", comment: ""))
        self.quoteLabel.text =  String(NSLocalizedString("If we did all the things we are capable of, we would literally astound ourselves.", comment: ""))
        activityIndicatorView.backgroundColor = UIColor.clearColor()
        
        addGradientView()
    }
    
    func addGradientView(){
        // Gradient for background image
        let backgroundImageGradient: CAGradientLayer = CAGradientLayer()
        backgroundImageGradient.frame = self.view.bounds
        let colorTop = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4).CGColor
        let colorBottom = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4).CGColor
        
        backgroundImageGradient.colors = [colorTop, colorBottom]
        self.backgroundImageView.layer.insertSublayer(backgroundImageGradient, atIndex: 0)
    }
    

    
    func generateRandomNumer()->Int{
        let max: UInt32 = UInt32(quotesObjArray.count)
        let randomNumber = Int(arc4random_uniform(max))
        return randomNumber
    }
    
    func getCurrentLanguage()->String{
        let langString = NSLocale.preferredLanguages()[0] as String
        if langString.containsString("es"){
            return "es"
        }else{
            return "en"
        }

    }
    
    
    func setupiAd(){
        /*
        self.canDisplayBannerAds = true
        bannerView = ADBannerView(adType: .Banner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.delegate = self
        bannerView.hidden = true
        view.addSubview(bannerView)
        
        let viewsDictionary = ["bannerView": bannerView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
        */
        
        self.canDisplayBannerAds = true
        self.bannerViewOutlet.hidden = true
        self.bannerViewOutlet.delegate = self
    }
    
    
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.backgroundImageView.layer.sublayers?.first?.frame = self.view.bounds
        
    }
    
    // MARK: ADBanner Delegates
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print("Show banner")
        //bannerView.hidden = false
        self.bannerViewOutlet.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("error \(error)")
        //bannerView.hidden = true
        self.bannerViewOutlet.hidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
