//
//  Quote.swift
//  InpireMe
//
//  Created by Dante Solorio on 11/27/15.
//  Copyright © 2015 Zahui Software. All rights reserved.
//

import UIKit

class Quote: NSObject {
    let quote: String
    let author: String
    
    init(quote:String, author:String){
        self.quote = quote
        self.author = author
    }

}
