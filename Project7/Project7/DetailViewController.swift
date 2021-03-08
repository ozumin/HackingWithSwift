//
//  DetailViewController”ViewController.swift
//  Project7
//
//  Created by Mizuo Nagayama on 2021/03/07.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 120%; }
            .container { margin-right: 5%; margin-left: 5%; }
        </style>
        </head>
        <body>
            <div class="container">
                <h2>
                    \(detailItem.title)
                </h2>
                <br>
                \(detailItem.body)
            </div>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

}
