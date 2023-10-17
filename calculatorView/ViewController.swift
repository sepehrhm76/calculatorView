//
//  ViewController.swift
//  calculatorView
//
//  Created by sepehr hajimohammadi on 10/4/23.
//

import UIKit
import AudioToolbox

class CustomGrayButton: UIButton {
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
//            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.850980401, alpha: 1)
        }, completion: nil)
    }
    
    private func unhighlightButton() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
//            self.transform = .identity// CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.backgroundColor = #colorLiteral(red: 0.6470588446, green: 0.6470588446, blue: 0.6470588446, alpha: 1)
        }, completion: nil)
    }
}

class CustomOrangeButton: UIButton {
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
            self.backgroundColor = #colorLiteral(red: 0.9877180457, green: 0.7791343331, blue: 0.55313164, alpha: 1)
        }, completion: nil)
    }
    
    private func unhighlightButton() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            self.backgroundColor = #colorLiteral(red: 0.9992796779, green: 0.6223273277, blue: 0.06129615009, alpha: 1)
        }, completion: nil)
    }
}

class CustomNumberButton: UIButton {
    
    //        addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: .touchDown)
//    self.addTarget(UIButton, action: <#T##Selector#>, for: .touchCancel)
//    init() {
//        super.init(frame: .zero)
//        
//        addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightButton()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        unhighlightButton()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let point: CGPoint = touches.first?.location(in: self) {
            if ((point.x < 0 || point.x > bounds.width) || (point.y < 0 || point.y > bounds.height)) {
                unhighlightButton()
            } else {
                highlightButton()
            }
        }
    }

    private func highlightButton() {
        UIView.animate(withDuration: 0, delay: 0, options: .allowUserInteraction, animations: {
            self.backgroundColor = #colorLiteral(red: 0.4509803653, green: 0.4509803057, blue: 0.4509803057, alpha: 1)
        }, completion: nil)
    }

    private func unhighlightButton() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            self.backgroundColor = #colorLiteral(red: 0.1999998987, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
        }, completion: nil)
    }
}



class ViewController: UIViewController {
    
    let display = UIView(frame: CGRect(x: 70, y: 0, width: 380, height: 350))
    lazy var buttonHeight = (view.bounds.height - 580) / 4
    let buttonBackgroundColor = #colorLiteral(red: 0.1999998987, green: 0.1999999881, blue: 0.1999999881, alpha: 1)
    let orangeButtonsColor = #colorLiteral(red: 0.9992719293, green: 0.6223490238, blue: 0.04383140057, alpha: 1)
    let grayButtonsColor = #colorLiteral(red: 0.6470588446, green: 0.6470588446, blue: 0.6470588446, alpha: 1)
    var marksFontSize = 42
    var isClicked = false
    var fontSize = 32
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
        text.adjustsFontSizeToFitWidth = true
        text.tintColor = UIColor.clear
        text.font = UIFont.systemFont(ofSize: CGFloat(90), weight: .thin)
        return text
    }()
    
    private lazy var c: CustomGrayButton = {
        let button = CustomGrayButton()
        button.backgroundColor = grayButtonsColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("AC", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .regular)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var negetiveNumber: CustomGrayButton = {
        let button = CustomGrayButton()
        button.backgroundColor = grayButtonsColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+/-", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .regular)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var percentSign: CustomGrayButton = {
        let button = CustomGrayButton()
        button.backgroundColor = grayButtonsColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("%", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var divide: CustomOrangeButton = {
        let button = CustomOrangeButton()
        button.backgroundColor = orangeButtonsColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("÷", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.marksFontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var times: CustomOrangeButton = {
        let button = CustomOrangeButton()
        button.backgroundColor = orangeButtonsColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("×", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.marksFontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var minus: CustomOrangeButton = {
        let button = CustomOrangeButton()
        button.backgroundColor = orangeButtonsColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("–", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.marksFontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var plus: CustomOrangeButton = {
        let button = CustomOrangeButton()
        button.backgroundColor = orangeButtonsColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.marksFontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var equal: CustomOrangeButton = {
        let button = CustomOrangeButton()
        button.backgroundColor = orangeButtonsColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("=", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.marksFontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var number7: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("7", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var number8: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("8", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var number9: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("9", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
   
    
    private lazy var number4: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("4", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var number5: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("5", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var number6: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("6", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    
    
    private lazy var number1: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("1", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var number2: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var number3: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("3", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
  
    
    private lazy var number0: CustomNumberButton = {
        let button = CustomNumberButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        button.backgroundColor = buttonBackgroundColor
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var dot: CustomNumberButton = {
        let button = CustomNumberButton()
        button.backgroundColor = buttonBackgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(".", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.fontSize), weight: .semibold)
        button.layer.cornerRadius = (buttonHeight) / 2
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
        
        c.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        c.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        negetiveNumber.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        negetiveNumber.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        percentSign.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        percentSign.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        divide.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        divide.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number7.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        number7.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number8.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        number8.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number9.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        number9.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        times.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        times.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number4.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        number4.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number5.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        number5.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number6.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        number6.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        minus.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        minus.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number1.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        number1.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number2.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        number2.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number3.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        number3.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        plus.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        plus.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        number0.widthAnchor.constraint(equalToConstant: buttonHeight * 2 + 15).isActive = true
        number0.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        dot.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        dot.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        equal.widthAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        equal.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        displayText.widthAnchor.constraint(equalToConstant: display.frame.width).isActive = true
        displayText.heightAnchor.constraint(equalToConstant: display.frame.height).isActive = true
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





