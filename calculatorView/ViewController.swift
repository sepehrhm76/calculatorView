//
//  ViewController.swift
//  calculatorView
//
//  Created by sepehr hajimohammadi on 10/4/23.
//

import UIKit
import AudioToolbox

class CustomButton: UIButton {
    var buttonColor: UIColor
    var fontSize: CGFloat
    
    init(title: String, target: Any?, action: Selector, buttonColor: UIColor, fontSize: CGFloat) {
        self.buttonColor = buttonColor
        self.fontSize = fontSize
        super.init(frame: .zero)
        self.backgroundColor = buttonColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        self.layer.cornerRadius = 44
        self.addTarget(target, action: action, for: .touchUpInside)
        self.widthAnchor.constraint(equalToConstant: 88).isActive = true
        self.heightAnchor.constraint(equalToConstant: 88).isActive = true
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
//        unhighlightButton(color: <#UIColor#>)
    }
    
    private func highlightButton() {
        UIView.animate(withDuration: 0, delay: 0, options: .allowUserInteraction, animations: {
            self.backgroundColor = self.highlightedColor()
        }, completion: nil)
    }
    
    private func unhighlightButton(color: UIColor) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            self.backgroundColor = color
        }, completion: nil)
    }
    
    func highlightedColor() -> UIColor {

        return buttonColor
    }
}

class CustomGrayButton: CustomButton {
     let grayButtonColor = #colorLiteral(red: 0.6470588446, green: 0.6470588446, blue: 0.6470588446, alpha: 1)
     let animationGrayColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.850980401, alpha: 1)
    
    init(title: String, target: Any?, action: Selector) {
        super.init(title: title, target: target, action: action, buttonColor: grayButtonColor, fontSize: 32)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(32), weight: .regular)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomOrangeButton: CustomButton {
     let orangeButtonsColor = #colorLiteral(red: 0.9992719293, green: 0.6223490238, blue: 0.04383140057, alpha: 1)
     let animationOrangeColor = #colorLiteral(red: 0.9877180457, green: 0.7791343331, blue: 0.55313164, alpha: 1)
    
    init(title: String, target: Any?, action: Selector) {
        super.init(title: title, target: target, action: action, buttonColor: orangeButtonsColor, fontSize: 42)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomNumberButton: CustomButton {
     let numberButtonColor = #colorLiteral(red: 0.1999998987, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
     let animationNumberColor = #colorLiteral(red: 0.4509803653, green: 0.4509803057, blue: 0.4509803057, alpha: 1)
    
    init(title: String, target: Any?, action: Selector) {
        super.init(title: title, target: target, action: action, buttonColor: numberButtonColor, fontSize: 32)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    let display = UIView(frame: CGRect(x: 70, y: 0, width: 380, height: 350))
    lazy var buttonHeight = (view.bounds.height - 580) / 4
    var isClicked = false
    var separatorCount = 0
    
    private func hasDisplaySpace() -> Bool {
        if let text = displayText.text {
            if (text.count < 10) {
                return true
            } else if (separatorCount == 1 && text.count < 10) {
                return true
            } else if (separatorCount == 2 && text.count < 11) {
                return true
            } else if (text.contains(".") && separatorCount == 0 && text.count < 10) {
                return true
            } else if (text.contains(".") && separatorCount == 1 && text.count < 11) {
                return true
            } else if (text.contains(".") && separatorCount == 2 && text.count < 12) {
                return true
            }
        }
        return false
    }
    
    private func removeSeparator(displayNumber: String) -> Double {
        let displayTextWithoutSeparator = displayText.text?.replacingOccurrences(of: ",", with: "")
        let displayNumberToDouble = Double(displayTextWithoutSeparator!)
        return displayNumberToDouble!
    }
    
    func formatNumber(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    private func checkDisplayBeFormatted() {
        if let text = displayText.text, !text.contains(".") && text != "-0" {
            let filteredValue = displayText.text!.replacingOccurrences(of: ",", with: "")
            let valueToDouble = Double(filteredValue)
            let valueWithFormat = formatNumber(valueToDouble!)
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
        text.font = UIFont.systemFont(ofSize: CGFloat(90), weight: .thin)
        text.adjustsFontSizeToFitWidth = true
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
    
    private lazy var number0: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        button.backgroundColor = #colorLiteral(red: 0.1999998987, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(32), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right, .left:
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
                
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayText.inputView = UIView()
        self.displayText.inputAccessoryView = UIView()
        
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
        let constraintDisplayText2 = NSLayoutConstraint(item: displayText, attribute: .bottom, relatedBy: .equal, toItem: display, attribute: .bottom, multiplier: 1.0, constant: 0)
        
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
        
        number0.widthAnchor.constraint(equalToConstant: buttonHeight * 2 + 15).isActive = true
        number0.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
    
    private func numberButtonAction(_ number: Int) {
        playTouchSound()
        isClicked = true
        if (displayText.text == "0") {
            displayText.text = ""
        } else if (displayText.text == "-0") {
            displayText.text = "-"
        }
        c.setTitle("C", for: .normal)
        if (hasDisplaySpace()) {
            displayText.text! += String(number)
        }
        print(number)
        checkDisplayBeFormatted()
    }
    
    private func cButtonAction() {
        playTouchSound()
        isClicked = false
        c.setTitle("AC", for: .normal)
        displayText.text! = "0"
        print("C")
    }
    
    private func number0ButtonAction() {
        playTouchSound()
        if (displayText.text != "0" && displayText.text != "-0") {
            isClicked = true
            if (hasDisplaySpace()) {
                displayText.text! += "0"
            }
        }
        if (displayText.text == "-0") {
            c.setTitle("C", for: .normal)
        }
        print("0")
        checkDisplayBeFormatted()
    }
    
    private func negetiveNumberButtonAction() {
        playTouchSound()
        
        if (displayText.text?.contains("-") == false) {
            
            let a = "-" + displayText.text!
            displayText.text = a
        } else {
            displayText.text?.removeFirst()
        }
        
        print("+/-")
    }
    
    private func percentSignButtonAction() {
        playTouchSound()
        if (displayText.text == "-0") {
            displayText.text = "0"
        }
        
        if (isClicked) {
            c.setTitle("C", for: .normal)
            displayText.text = String(removeSeparator(displayNumber: displayText.text!) / 100)
        }
        print("%")
        checkDisplayBeFormatted()
    }
    
    private func dotButtonAction() {
        playTouchSound()
        isClicked = true
        if (displayText.text?.contains(".") == false && displayText.text!.count < 11) {
            c.setTitle("C", for: .normal)
            displayText.text! += "."
        }
        print(".")
        checkDisplayBeFormatted()
    }
    
    private func equalButtonAction() {
        playTouchSound()
    }
    
    private func plusButtonAction() {
        playTouchSound()
    }
    
    private func minusButtonAction() {
        playTouchSound()
    }
    
    private func timesButtonAction() {
        playTouchSound()
    }
    
    private func divideButtonAction() {
        playTouchSound()
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
            number0ButtonAction()
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
            plusButtonAction()
        case minus:
            minusButtonAction()
        case times:
            timesButtonAction()
        case divide:
            divideButtonAction()
        default:
            return
        }
    }
}





