import UIKit

/*
 Swift Attribute(속성)
 @IBInspectable, @IBDesignable, @objc, @escaping
 @available, @discardableResult etc.
 */

// 런타임 시점 말고 스토리 보드에서 디자인을 보고 싶다면 Designable 추가
@IBDesignable
class SeSACButton: UIButton {

    // 인터페이스 빌더 인스펙터 영역 Show
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}
