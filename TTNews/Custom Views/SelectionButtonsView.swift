//
//  SelectionButtonsView.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/12/22.
//

import UIKit

protocol SelectionButtonsViewDelegate: AnyObject {
    func buttonShouldChange(newSelection: [String]) -> Bool
}

/// A view that contains toggle buttons which lays from left to right and top to bottom.
/// Users can select/cancel each button for desired configuration.
///
/// The leading, trailing, top needs to be defined. The bottom would automatically strectch
/// based on the buttons layout. Call `configureSelectionOptions(titles:)` to add buttons.
class SelectionButtonsView: UIView {

    var buttons: [UIButton] = []
    weak var delegate: SelectionButtonsViewDelegate?
    
    private var width: CGFloat = 0
    private var height: CGFloat = 0
    private let paddingX: CGFloat = 15
    private let paddingY: CGFloat = 5
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutButtons()
    }
    
    /// Create toggle buttons from `titles` array
    ///
    /// ```
    /// let categories = ["General", "Business"]
    /// configureSelectionOptions(titles: categories)
    /// ```
    func configureSelectionOptions(titles: [String]) {
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.sizeToFit()
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.isSelected = true
            buttons.append(button)
            self.addSubview(button)
        }
    }
    
    private func layoutButtons() {
        // Get the superview's width. Layout the buttons one by one from left to right, top to bottom.
        width = self.frame.width
        assert(width > 0)
        var x = 0.0, y = 0.0
        
        
        for button in buttons {
            let buttonWidth = button.frame.width
            let buttonHeight = button.frame.height
            
            // This row does not have enough space. Switch to next row.
            if x + buttonWidth > width {
                x = 0
                y = y + paddingY + buttonHeight
            }
            button.frame = CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)
            x += buttonWidth + paddingX
            height = y + buttonHeight
        }
        
        // causes self view take the intrinsic content size into account and redraw
        invalidateIntrinsicContentSize()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let delegate = delegate, !delegate.buttonShouldChange(newSelection: getSelection()) {
            sender.isSelected = !sender.isSelected
            return
        }
    }
    
    /// - Returns: A String array containing all selected options
    func getSelection() -> [String] {
        var selectedOptions = [String]()
        for button in buttons {
            guard button.isSelected else { continue }
            guard let text = button.titleLabel?.text else { continue }
            selectedOptions.append(text.lowercased())
        }
        return selectedOptions
    }
}
