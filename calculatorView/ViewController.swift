//
//  ViewController.swift
//  calculatorView
//
//  Created by sepehr hajimohammadi on 10/4/23.
import UIKit
import AudioToolbox

class CustomButton: UIButton {
    var buttonColor: UIColor
    var highlightColor: UIColor
    var fontSize: CGFloat
    var buttonSize: CGSize
    
    init(title: String, target: Any?, action: Selector, buttonColor: UIColor,highlightColor: UIColor ,fontSize: CGFloat, buttonSize: CGSize = CGSize(width: 88, height: 88)) {
        self.buttonColor = buttonColor
        self.highlightColor = highlightColor
        self.fontSize = fontSize
        self.buttonSize = buttonSize
        super.init(frame: .zero)
        self.backgroundColor = buttonColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        self.layer.cornerRadius = 44
        self.addTarget(target, action: action, for: .touchUpInside)
        self.widthAnchor.constraint(equalToConstant: buttonSize.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: buttonSize.height).isActive = true
        
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightButton()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        unhighlightButton()
    }
    
    private func highlightButton() {
        UIView.animate(withDuration: 0, delay: 0, options: .allowUserInteraction, animations: {
            self.backgroundColor = self.highlightColor
        }, completion: nil)
    }
    
    private func unhighlightButton() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            self.backgroundColor = self.buttonColor
        }, completion: nil)
    }
    
    func highlightedColor() -> UIColor {
        return buttonColor
    }
    
    private func setupGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let touchLocation = sender.location(in: self)
        var lastButton: CustomButton? // To keep track of the last button entered
        
        if self.point(inside: touchLocation, with: nil) {
            // If the finger is inside the button while panning, highlight it
            if (!isHighlighted) {
                highlightButton()
                isHighlighted = true
            }
        } else {
            // If the finger is outside the button while panning, unhighlight it
            if isHighlighted {
                unhighlightButton()
                isHighlighted = false
            }
        }
        
        // Detect if the finger swipes into another button
        if let superview = self.superview {
            for subview in superview.subviews {
                if let otherButton = subview as? CustomButton, otherButton != self {
                    let touchLocationInOtherButton = sender.location(in: otherButton)
                    if otherButton.point(inside: touchLocationInOtherButton, with: nil) {
                        otherButton.highlightButton()
                        lastButton = otherButton// Update the last button
                    } else {
                        otherButton.unhighlightButton()
                    }
                }
            }
        }
        
        // If the gesture state ends, perform the action on the last button
        if sender.state == .ended {
            lastButton?.unhighlightButton()
            lastButton?.sendActions(for: .touchUpInside)
            if isHighlighted {
                lastButton?.sendActions(for: .touchUpInside)
                
            }
        }
    }
}

class CustomGrayButton: CustomButton {
    let grayButtonColor = #colorLiteral(red: 0.6470588446, green: 0.6470588446, blue: 0.6470588446, alpha: 1)
    let animationGrayColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.850980401, alpha: 1)
    
    init(title: String, target: Any?, action: Selector) {
        super.init(title: title, target: target, action: action, buttonColor: grayButtonColor,highlightColor: animationGrayColor ,fontSize: 32)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(32), weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomOrangeButton: CustomButton {
    var orangeButtonsColor = #colorLiteral(red: 0.9992719293, green: 0.6223490238, blue: 0.04383140057, alpha: 1)
    var animationOrangeColor = #colorLiteral(red: 0.9877180457, green: 0.7791343331, blue: 0.55313164, alpha: 1)
    
    init(title: String, target: Any?, action: Selector) {
        super.init(title: title, target: target, action: action, buttonColor: orangeButtonsColor,highlightColor: animationOrangeColor ,fontSize: 42)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomNumberButton: CustomButton {
    let numberButtonColor = #colorLiteral(red: 0.1999998987, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
    let animationNumberColor = #colorLiteral(red: 0.4509803653, green: 0.4509803057, blue: 0.4509803057, alpha: 1)
    
    init(title: String, size : CGSize = CGSize(width: 88, height: 88), target: Any?, action: Selector) {
        super.init(title: title, target: target, action: action, buttonColor: numberButtonColor,highlightColor: animationNumberColor ,fontSize: 32, buttonSize: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    let display = UIView(frame: CGRect(x: 70, y: 0, width: 380, height: 350))
    lazy var buttonHeight = (view.bounds.height - 580) / 4
    var isClicked = false
    var isopperationSelected = false
    var isResult = false
    var canNumberRemove = true
    var separatorCount = 0
    var all : [String] = []
    var allCopy : [String] = []
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    private func hasDisplaySpace() -> Bool {
        var displayTextWithoutChar = displayText.text?.replacingOccurrences(of: ".", with: "")
        displayTextWithoutChar = displayTextWithoutChar?.replacingOccurrences(of: ",", with: "")
        if (displayTextWithoutChar?.count ?? 0) < 9 {
            return true
        } else {
            return false
        }
    }
    
    private func removeSeparator(displayNumber: String) -> String {
        let displayTextWithoutSeparator = displayText.text?.replacingOccurrences(of: ",", with: "")
        return displayTextWithoutSeparator ?? ""
    }
    
    private func formatNumber(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        } else {
            numberFormatter.minimumFractionDigits = 1
            numberFormatter.maximumFractionDigits = 10
        }
        
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    private func checkDisplayBeFormatted() {
        if let text = displayText.text, !text.contains(".") && text != "-0" {
            let filteredValue = displayText.text?.replacingOccurrences(of: ",", with: "")
            let valueToDouble = Double(filteredValue ?? "")
            let valueWithFormat = formatNumber(valueToDouble ?? 0)
            displayText.text = valueWithFormat
            separatorCount = (displayText.text?.filter { $0 == "," }.count)!
        }
    }
    
    private func playTouchSound() {
        AudioServicesPlaySystemSound(1104)
    }
    
    private lazy var displayText: UITextField = {
        let text = UITextField()
        text.textColor = .white
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "0"
        text.textAlignment = .right
        text.tintColor = UIColor.clear
        text.font = UIFont.systemFont(ofSize: 93, weight: .thin)
        text.adjustsFontSizeToFitWidth = true
        text.isUserInteractionEnabled = false
        return text
    }()
    
    private lazy var c: CustomGrayButton = {
        return CustomGrayButton(title: "AC", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var negetiveNumber: CustomGrayButton = {
        return CustomGrayButton(title: "+/-", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var percentSign: CustomGrayButton = {
        return CustomGrayButton(title: "%", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var divide: CustomOrangeButton = {
        return CustomOrangeButton(title: "÷", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var times: CustomOrangeButton = {
        return CustomOrangeButton(title: "×", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var minus: CustomOrangeButton = {
        return CustomOrangeButton(title: "–", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var plus: CustomOrangeButton = {
        return CustomOrangeButton(title: "+", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var dot: CustomNumberButton = {
        return CustomNumberButton(title: ".", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var equal: CustomOrangeButton = {
        return CustomOrangeButton(title: "=", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number1: CustomNumberButton = {
        return CustomNumberButton(title: "1", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number2: CustomNumberButton = {
        return CustomNumberButton(title: "2", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number3: CustomNumberButton = {
        return CustomNumberButton(title: "3", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number4: CustomNumberButton = {
        return CustomNumberButton(title: "4", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number5: CustomNumberButton = {
        return CustomNumberButton(title: "5", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number6: CustomNumberButton = {
        return CustomNumberButton(title: "6", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number7: CustomNumberButton = {
        return CustomNumberButton(title: "7", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number8: CustomNumberButton = {
        return CustomNumberButton(title: "8", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number9: CustomNumberButton = {
        return CustomNumberButton(title: "9", target: self, action: #selector(buttonAction))
    }()
    
    private lazy var number0: CustomNumberButton = {
        let button = CustomNumberButton(title: "0", size: CGSize(width: 191, height: 88), target: self, action: #selector(buttonAction))
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right, .left:
                if (canNumberRemove) {
                    if let text = displayText.text, !text.isEmpty, text != "-0" {
                        displayText.text?.removeLast()
                    } else {
                        displayText.text = "0"
                    }
                    
                    if displayText.text?.isEmpty == true {
                        displayText.text = "0"
                    }
                    
                    if displayText.text?.count == 1, displayText.text?.contains("-") == true {
                        displayText.text = "-0"
                    }
                    checkDisplayBeFormatted()
                }
            default:
                break
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.display.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.display.addGestureRecognizer(swipeLeft)
        
        view.addSubview(c)
        view.addSubview(negetiveNumber)
        view.addSubview(percentSign)
        view.addSubview(divide)
        view.addSubview(number7)
        view.addSubview(number8)
        view.addSubview(number9)
        view.addSubview(times)
        view.addSubview(number4)
        view.addSubview(number5)
        view.addSubview(number6)
        view.addSubview(minus)
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(plus)
        view.addSubview(number0)
        view.addSubview(dot)
        view.addSubview(equal)
        view.addSubview(display)
        display.addSubview(displayText)
        
        let constraintDisplayText1 = NSLayoutConstraint(item: displayText, attribute: .right, relatedBy: .equal, toItem: display, attribute: .right, multiplier: 1.0, constant: -55)
        let constraintDisplayText2 = NSLayoutConstraint(item: displayText, attribute: .bottom, relatedBy: .equal, toItem: display, attribute: .bottom, multiplier: 1.0, constant: 120)
        
        let constraintC1 = NSLayoutConstraint(item: c, attribute: .top, relatedBy: .equal, toItem: display, attribute: .bottom, multiplier: 1.0, constant: 10)
        let constraintC2 = NSLayoutConstraint(item: c, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 16)
        
        let constraintNegetiveNumber1 = NSLayoutConstraint(item: negetiveNumber, attribute: .top, relatedBy: .equal, toItem: display, attribute: .bottom, multiplier: 1.0, constant: 10)
        let constraintNegetiveNumber2 = NSLayoutConstraint(item: negetiveNumber, attribute: .left, relatedBy: .equal, toItem: c, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintPercentSign1 = NSLayoutConstraint(item: percentSign, attribute: .top, relatedBy: .equal, toItem: display, attribute: .bottom, multiplier: 1.0, constant: 10)
        let contraintPercentSign2 = NSLayoutConstraint(item: percentSign, attribute: .left, relatedBy: .equal, toItem: negetiveNumber, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintDivide1 = NSLayoutConstraint(item: divide, attribute: .top, relatedBy: .equal, toItem: display, attribute: .bottom, multiplier: 1.0, constant: 10)
        let contraintDivide2 = NSLayoutConstraint(item: divide, attribute: .left, relatedBy: .equal, toItem: percentSign, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintNumber7_1 = NSLayoutConstraint(item: number7, attribute: .top, relatedBy: .equal, toItem: c, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber7_2 = NSLayoutConstraint(item: number7, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 16)
        
        let contraintNumber8_1 = NSLayoutConstraint(item: number8, attribute: .top, relatedBy: .equal, toItem: negetiveNumber, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber8_2 = NSLayoutConstraint(item: number8, attribute: .left, relatedBy: .equal, toItem: number7, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintNumber9_1 = NSLayoutConstraint(item: number9, attribute: .top, relatedBy: .equal, toItem: percentSign, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber9_2 = NSLayoutConstraint(item: number9, attribute: .left, relatedBy: .equal, toItem: number8, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintTimes1 = NSLayoutConstraint(item: times, attribute: .top, relatedBy: .equal, toItem: divide, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintTimes2 = NSLayoutConstraint(item: times, attribute: .left, relatedBy: .equal, toItem: number9, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintNumber4_1 = NSLayoutConstraint(item: number4, attribute: .top, relatedBy: .equal, toItem: number7, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber4_2 = NSLayoutConstraint(item: number4, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 16)
        
        let contraintNumber5_1 = NSLayoutConstraint(item: number5, attribute: .top, relatedBy: .equal, toItem: number8, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber5_2 = NSLayoutConstraint(item: number5, attribute: .left, relatedBy: .equal, toItem: number4, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintNumber6_1 = NSLayoutConstraint(item: number6, attribute: .top, relatedBy: .equal, toItem: number9, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber6_2 = NSLayoutConstraint(item: number6, attribute: .left, relatedBy: .equal, toItem: number5, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintMinus1 = NSLayoutConstraint(item: minus, attribute: .top, relatedBy: .equal, toItem: times, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintMinus2 = NSLayoutConstraint(item: minus, attribute: .left, relatedBy: .equal, toItem: number6, attribute: .right, multiplier: 1.0, constant: 16)
        
        let contraintNumber1_1 = NSLayoutConstraint(item: number1, attribute: .top, relatedBy: .equal, toItem: number4, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber1_2 = NSLayoutConstraint(item: number1, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 15)
        
        let contraintNumber2_1 = NSLayoutConstraint(item: number2, attribute: .top, relatedBy: .equal, toItem: number5, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber2_2 = NSLayoutConstraint(item: number2, attribute: .left, relatedBy: .equal, toItem: number1, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintNumber3_1 = NSLayoutConstraint(item: number3, attribute: .top, relatedBy: .equal, toItem: number6, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber3_2 = NSLayoutConstraint(item: number3, attribute: .left, relatedBy: .equal, toItem: number2, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintPlus1 = NSLayoutConstraint(item: plus, attribute: .top, relatedBy: .equal, toItem: minus, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintPlus2 = NSLayoutConstraint(item: plus, attribute: .left, relatedBy: .equal, toItem: number3, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintNumber0_1 = NSLayoutConstraint(item: number0, attribute: .top, relatedBy: .equal, toItem: number1, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintNumber0_2 = NSLayoutConstraint(item: number0, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 16)
        
        let contraintDot1 = NSLayoutConstraint(item: dot, attribute: .top, relatedBy: .equal, toItem: number3, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintDot2 = NSLayoutConstraint(item: dot, attribute: .left, relatedBy: .equal, toItem: number0, attribute: .right, multiplier: 1.0, constant: 15)
        
        let contraintEqual1 = NSLayoutConstraint(item: equal, attribute: .top, relatedBy: .equal, toItem: plus, attribute: .bottom, multiplier: 1.0, constant: 15)
        let contraintEqual2 = NSLayoutConstraint(item: equal, attribute: .left, relatedBy: .equal, toItem: dot, attribute: .right, multiplier: 1.0, constant: 15)
        
        NSLayoutConstraint.activate([constraintC1, constraintC2, constraintNegetiveNumber1, constraintNegetiveNumber2, contraintPercentSign1, contraintPercentSign2, contraintDivide1, contraintDivide2, contraintNumber7_1, contraintNumber7_2, contraintNumber8_1, contraintNumber8_2, contraintNumber9_1, contraintNumber9_2, contraintTimes1, contraintTimes2, contraintNumber4_1, contraintNumber4_2, contraintNumber5_1, contraintNumber5_2, contraintNumber6_1, contraintNumber6_2, contraintMinus1, contraintMinus2, contraintNumber1_1, contraintNumber1_2, contraintNumber2_1, contraintNumber2_2, contraintNumber3_1, contraintNumber3_2, contraintPlus1, contraintPlus2, contraintNumber0_1, contraintNumber0_2, contraintDot1, contraintDot2, contraintEqual1, contraintEqual2, constraintDisplayText1, constraintDisplayText2])
        
        displayText.widthAnchor.constraint(equalToConstant: display.frame.width).isActive = true
        displayText.heightAnchor.constraint(equalToConstant: display.frame.height).isActive = true
    }
    
    private func numberButtonAction(_ number: Int) {
        playTouchSound()
        isClicked = true
        canNumberRemove = true
        if (isopperationSelected || isResult) {
            displayText.text = ""
            isopperationSelected = false
            isResult = false
        }
        
        if (number == 0) {
            if (displayText.text != "0" && displayText.text != "-0") {
                if (hasDisplaySpace()) {
                    displayText.text? += "0"
                }
            }
            if (displayText.text == "-0") {
                c.setTitle("C", for: .normal)
            }
            
        } else {
            
            if (displayText.text == "0") {
                displayText.text = ""
                
            } else if (displayText.text == "-0") {
                displayText.text = "-"
            }
            
            c.setTitle("C", for: .normal)
            if (hasDisplaySpace()) {
                displayText.text? += String(number)
            }
        }
        checkDisplayBeFormatted()
    }
    
    private func cButtonAction() {
        playTouchSound()
        isClicked = false
        c.setTitle("AC", for: .normal)
        displayText.text = "0"
        all.removeAll()
        allCopy.removeAll()
        isopperationSelected = false
        isResult = false
    }
    
    private func negetiveNumberButtonAction() {
        playTouchSound()
        if (displayText.text != "Error" && displayText.text != "Out of space") {
            if (displayText.text?.contains("-") == false) {
                let a = "-" + (displayText.text ?? "")
                displayText.text = a
            } else {
                displayText.text?.removeFirst()
            }
        }
    }
    
    private func percentSignButtonAction() {
        playTouchSound()
        if (displayText.text == "-0") {
            displayText.text = "0"
        }
        if (isClicked) {
            c.setTitle("C", for: .normal)
            let a = removeSeparator(displayNumber: displayText.text ?? "")
            checkDisplayBeFormatted()
            if (hasDisplaySpace()) {
                displayText.text =  formatNumber((Double(a) ?? 0) / 100)}
            canNumberRemove = false
        }
    }
    
    private func dotButtonAction() {
        playTouchSound()
        isClicked = true
        if (displayText.text != "Error" && displayText.text != "Out of space") {
            if (displayText.text?.contains(".") == false && displayText.text?.count ?? 100 < 11) {
                c.setTitle("C", for: .normal)
                displayText.text? += "."
            }
        }
        checkDisplayBeFormatted()
    }
    
    private func equalButtonAction() {
        playTouchSound()
        canNumberRemove = false
        isopperationSelected = false
        if (!isResult) {
            all.append(String(removeSeparator(displayNumber: displayText.text ?? "")))
            allCopy.append(contentsOf: all)
            if (formatNumber(calculateResult(all) ?? 0) != "+∞") {
                
                displayText.text = formatNumber(calculateResult(all) ?? 0)
                
            } else {
                displayText.text = "Error"
            }
            all.removeAll()
            isResult = true
        } else if (isResult && displayText.text != "Error" || displayText.text != "Out of space") {
            let allCopyLast = allCopy.last
            let allCopyOperationElement = allCopy.count - 2
            let lastOperation = allCopy[allCopyOperationElement]
            allCopy.removeAll()
            allCopy.append(String(removeSeparator(displayNumber: displayText.text ?? "")))
            allCopy.append(lastOperation)
            allCopy.append(allCopyLast ?? "")
            if (hasDisplaySpace()) {
                displayText.text = formatNumber(calculateResult(allCopy) ?? 0)
            } else {
                displayText.text = "Out of space"
            }
        }
    }
    
    private func operationPressed(operation: String) {
        playTouchSound()
        canNumberRemove = false
        if (displayText.text != "Error" && displayText.text != "Out of space") {
            isResult = false
            if (!isopperationSelected) {
                all.append(removeSeparator(displayNumber: displayText.text ?? ""))
                all.append(operation)
                isopperationSelected = true
            } else if (isopperationSelected && all.last != operation) {
                all.removeLast()
                all.append(operation)
            }
            displayText.text = formatNumber(calculateResult(all) ?? 0)
            if (operation == "+" || operation == "-") {
                displayText.text = formatNumber(calculateResult(all) ?? 0)
            } else if (operation == "*" || operation == "/") {
                let arrayCount = all.count
                let twoLastIndex = arrayCount - 2
                displayText.text = formatNumber(Double(all[twoLastIndex]) ?? 0)
            }
            isopperationSelected = true
        }
    }
    
    func calculateResult(_ input: [String]) -> Double? {
        var output: [String] = []
        var accumulator: Double? = nil
        
        for token in input {
            if let number = Double(token) {
                if let currentAccumulator = accumulator {
                    accumulator = nil
                    if output.last == "*" {
                        output.removeLast()
                        output.append(String(currentAccumulator * number))
                    } else if output.last == "/" {
                        output.removeLast()
                        output.append(String(currentAccumulator / number))
                    }
                } else {
                    output.append(token)
                }
            } else if token == "*" || token == "/" {
                if accumulator == nil {
                    accumulator = Double(output.removeLast())
                }
                output.append(token)
            } else {
                output.append(token)
            }
        }
        guard !output.isEmpty else {
            return nil
        }
        var result: Double = 0
        var operation: String = "+"
        
        for token in output {
            if let number = Double(token) {
                if operation == "+" {
                    result += number
                } else if operation == "-" {
                    result -= number
                }
            } else if token == "+" || token == "-" {
                operation = token
            }
        }
        return result
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        
        switch sender {
        case number1:
            numberButtonAction(1)
        case number2:
            numberButtonAction(2)
        case number3:
            numberButtonAction(3)
        case number4:
            numberButtonAction(4)
        case number5:
            numberButtonAction(5)
        case number6:
            numberButtonAction(6)
        case number7:
            numberButtonAction(7)
        case number8:
            numberButtonAction(8)
        case number9:
            numberButtonAction(9)
        case number0:
            numberButtonAction(0)
        case negetiveNumber:
            negetiveNumberButtonAction()
        case percentSign:
            percentSignButtonAction()
        case dot:
            dotButtonAction()
        case c:
            cButtonAction()
        case equal:
            equalButtonAction()
        case plus:
            operationPressed(operation: "+")
        case minus:
            operationPressed(operation: "-")
        case times:
            operationPressed(operation: "*")
        case divide:
            operationPressed(operation: "/")
        default:
            return
        }
    }
}
