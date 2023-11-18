//
//  PlayerSelector.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/29/23.
//

import UIKit

protocol PlayerSelectorDelegate {

    func isHumanButtonTapped(onTag tag: Int)

    func isComputerButtonTapped(onTag tag: Int)

    func updatePlayerEnable(onTag tag: Int)
}

class PlayerSelector: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    var _tag: Int = -1
    var delegate: PlayerSelectorDelegate?
    var viewHeight: CGFloat = 44
    var placeholderText: String = "Please enter player name"

    var _selectorColor: UIColor = .clear
    var selectorColor: UIColor {
        get {
            return _selectorColor
        }
        set {
            _selectorColor = newValue
            underlineView.backgroundColor = newValue
            layoutIfNeeded()
        }
    }

    var isEnabled: Bool {
        playerNameTextField.text != ""
    }

    var isHuman: Bool = false

    // MARK: - Views
    // Views
    lazy var uiHolderView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        return view
    }()

    lazy var underlineView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        uiHolderView.addSubview(view)

        return view
    }()

    lazy var isHumanButtonBorderView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        uiHolderView.addSubview(view)

        return view
    }()

    lazy var isComputerButtonBorderView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        uiHolderView.addSubview(view)

        return view
    }()

    // Buttons
    lazy var isHumanButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        isHumanButtonBorderView.addSubview(button)
        button.tag = tag

        button.addTarget(self,
                         action: #selector(isHumanButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var isComputerButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        isComputerButtonBorderView.addSubview(button)
        button.tag = tag

        button.addTarget(self,
                         action: #selector(isComputerButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // Textfields
    lazy var playerNameTextField: UITextField = {
        let textfield = UITextField()

        textfield.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textfield)
        textfield.tag = tag
        textfield.placeholder = placeholderText
        textfield.delegate = self
        textfield.textColor = .black

        return textfield
    }()

    // MARK: - Lifecycle
    init() {
        super.init(frame: CGRect())

        self.translatesAutoresizingMaskIntoConstraints = false

        setupViews()
        updateState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc func isHumanButtonTapped(sender: UIButton!) {
        isHuman = true
        delegate?.isHumanButtonTapped(onTag: tag)
    }

    @objc func isComputerButtonTapped(sender: UIButton!) {
        isHuman = false
        delegate?.isComputerButtonTapped(onTag: tag)
    }

    // MARK: - Conformance: UIView

    override var tag: Int {
        get {
            return _tag
        }
        set {
            _tag = newValue
            isHumanButton.tag = _tag
            isComputerButton.tag = _tag
            playerNameTextField.tag = _tag
        }
    }

    override func updateConstraints() {
        super.updateConstraints()

        if let constraint = self.constraints.first(where: { constraint in
            return constraint.isActive && constraint.firstAttribute == .height
        }) {
           constraint.constant = viewHeight
        }
        setupViews()
        updateState()
    }

    // MARK: - Conformance: UITextFieldDelegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.updatePlayerEnable(onTag: tag)
    }

    // MARK: - Helpers
    func setupViews() {
        uiHolderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        uiHolderView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        uiHolderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        uiHolderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        isComputerButton.topAnchor.constraint(equalTo: uiHolderView.topAnchor).isActive = true
        isComputerButton.bottomAnchor.constraint(equalTo: uiHolderView.bottomAnchor,
                                                 constant: 1).isActive = true
        isComputerButton.widthAnchor.constraint(equalTo: isComputerButton.heightAnchor).isActive = true
        isComputerButton.trailingAnchor.constraint(equalTo: uiHolderView.trailingAnchor).isActive = true

        isComputerButtonBorderView.topAnchor.constraint(equalTo: isComputerButton.topAnchor,
                                                     constant: 1).isActive = true
        isComputerButtonBorderView.leadingAnchor.constraint(equalTo: isComputerButton.leadingAnchor,
                                                         constant: 1).isActive = true
        isComputerButtonBorderView.trailingAnchor.constraint(equalTo: isComputerButton.trailingAnchor,
                                                          constant: -1).isActive = true
        isComputerButtonBorderView.bottomAnchor.constraint(equalTo: isComputerButton.bottomAnchor,
                                                        constant:  -1).isActive = true
        isComputerButtonBorderView.layer.borderWidth = 2
        isComputerButtonBorderView.layer.borderColor = selectorColor.cgColor
        isComputerButtonBorderView.layer.cornerRadius = 17

        isHumanButton.topAnchor.constraint(equalTo: uiHolderView.topAnchor).isActive = true
        isHumanButton.bottomAnchor.constraint(equalTo: uiHolderView.bottomAnchor,
                                              constant: 1).isActive = true
        isHumanButton.widthAnchor.constraint(equalTo: isHumanButton.heightAnchor).isActive = true
        isHumanButton.trailingAnchor.constraint(equalTo: isComputerButton.leadingAnchor,
                                                constant: -2).isActive = true

        isHumanButtonBorderView.topAnchor.constraint(equalTo: isHumanButton.topAnchor,
                                                     constant: 1).isActive = true
        isHumanButtonBorderView.leadingAnchor.constraint(equalTo: isHumanButton.leadingAnchor,
                                                         constant: 1).isActive = true
        isHumanButtonBorderView.trailingAnchor.constraint(equalTo: isHumanButton.trailingAnchor,
                                                          constant: -1).isActive = true
        isHumanButtonBorderView.bottomAnchor.constraint(equalTo: isHumanButton.bottomAnchor,
                                                        constant:  -1).isActive = true
        isHumanButtonBorderView.layer.borderWidth = 2
        isHumanButtonBorderView.layer.borderColor = selectorColor.cgColor
        isHumanButtonBorderView.layer.cornerRadius = 17

        playerNameTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        playerNameTextField.trailingAnchor.constraint(equalTo: isHumanButton.leadingAnchor,
                                                      constant: -2).isActive = true
        playerNameTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        

        underlineView.leadingAnchor.constraint(equalTo: playerNameTextField.leadingAnchor).isActive = true
        underlineView.trailingAnchor.constraint(equalTo: playerNameTextField.trailingAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: playerNameTextField.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underlineView.backgroundColor = selectorColor
    }

    func updateState() {
        if isEnabled {
            uiHolderView.alpha = 1
        } else {
            uiHolderView.alpha = 0.33
        }

        if isHuman {
            isComputerButton.setImage(nil, for: .normal)
            isHumanButton.setImage(UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            isComputerButton.setImage(UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            isHumanButton.setImage(nil, for: .normal)
        }
        isComputerButton.tintColor = selectorColor
        isHumanButton.tintColor = selectorColor
    }
}
