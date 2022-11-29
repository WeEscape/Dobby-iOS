//
//  PolicyViewController.swift
//  Dobby
//
//  Created by yongmin lee on 11/29/22.
//

import UIKit
import WebKit
import SnapKit

final class PolicyViewController: BaseViewController {
    
    // MARK: property
    let policyType: PolicyType
    
    // MARK: UI
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: policyType.url))
        return webView
    }()
    
    // MARK: init
    init(policyType: PolicyType) {
        self.policyType = policyType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = policyType.rawValue
        self.navigationController?.topViewController?.extendedLayoutIncludesOpaqueBars = true
        
        let navigationLineView = self.createLineView()
        self.view.addSubview(navigationLineView)
        navigationLineView.makeLineViewConstraints(
            topEqualTo: view.safeAreaLayoutGuide.snp.top
        )
        
        self.view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(navigationLineView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension PolicyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoading()
    }
}
