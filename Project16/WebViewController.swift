//
//  WebViewController.swift
//  Project16
//
//  Created by Mizuo Nagayama on 2021/04/15.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = url else { return }

        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
}
