//
//  UITextField+.swift
//  Dobby
//
//  Created by yongmin lee on 10/27/22.
//

import UIKit

class TextFieldWithPlaceholder: UITextField {
    
    init(placeholder: String, fontSize: CGFloat, textColor: UIColor) {
        super.init(frame: .zero)
        self.borderStyle = .none
        self.textColor = textColor
        self.font = DobbyFont.appleSDGothicNeoMedium(size: fontSize).getFont
        self.keyboardAppearance = .default
        self.translatesAutoresizingMaskIntoConstraints = false
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: Palette.textGray1,
                .font: DobbyFont.avenirLight(size: fontSize).getFont
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
