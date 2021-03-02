//
//  ViewController.swift
//  Project4
//
//  Created by Mizuo Nagayama on 2021/02/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    var selectedSite: String?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "<", style: .done, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: ">", style: .done, target: webView, action: #selector(webView.goForward))

        toolbarItems = [goBack, progressButton, spacer, refresh, goForward]
        navigationController?.isToolbarHidden = false

        let url = URL(string: "https://" + selectedSite!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            let ac = UIAlertController(title: "This page is not allowed to open", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
        decisionHandler(.cancel)
    }
}

