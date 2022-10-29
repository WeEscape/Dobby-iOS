//
//  ChoreMemoAttributeView.swift
//  Dobby
//
//  Created by yongmin lee on 10/24/22.
//

import UIKit
import SnapKit

final class ChoreMemoAttributeView: ChoreAttributeView {
    
    // MARK: property
    let memoPlaceHolder = "메모를 입력해주세요."
    
    // MARK: UI
    struct Metric {
        static let memoBodyFontSize: CGFloat = 12
        static let titleLabelLeftInset: CGFloat = 28
        static let titleLabelTopInset: CGFloat = 16
        static let memoTextViewTopMargin: CGFloat = 9
        static let memoTextViewLeftRightInset: CGFloat = 28
        static let memoTextViewHeight: CGFloat = 94
        static let textContainerTopBottomInset: CGFloat = 8
        static let textContainerleftRightInset: CGFloat = 11
    }
    
    private lazy var memoTextView: UITextView = {
        var textView = UITextView()
        textView.font = DobbyFont.avenirLight(size: Metric.memoBodyFontSize).getFont
        textView.textColor = Palette.textGray1
        textView.text = memoPlaceHolder
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.textContainerInset = UIEdgeInsets(
            top: Metric.textContainerTopBottomInset,
            left: Metric.textContainerleftRightInset,
            bottom: Metric.textContainerTopBottomInset,
            right: Metric.textContainerleftRightInset
        )
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()
    
    // MARK: init
    override init(attribute: ChoreAttribute) {
        super.init(attribute: attribute)
        self.gestureRecognizers?.forEach { [weak self] recognizer in
            self?.removeGestureRecognizer(recognizer)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: methods
    override func setupUI() {
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(Metric.titleLabelLeftInset)
            $0.top.equalToSuperview().inset(Metric.titleLabelTopInset)
        }
        
        self.addSubview(memoTextView)
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.memoTextViewTopMargin)
            $0.left.equalToSuperview().inset(Metric.memoTextViewLeftRightInset)
            $0.right.equalToSuperview().inset(Metric.memoTextViewLeftRightInset)
            $0.height.equalTo(Metric.memoTextViewHeight)
        }
    }
}

// MARK: extension UITextViewDelegate
extension ChoreMemoAttributeView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == memoPlaceHolder {
            textView.text = nil
            textView.textColor = Palette.textBlack1
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = memoPlaceHolder
            textView.textColor = Palette.textGray1
        }
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        // 글자수 100자 제한
        return textView.text.count + (text.count - range.length) <= 100
    }
}