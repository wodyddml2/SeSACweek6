import UIKit

/*
 애플에서 권장하지는 않지만 재사용성때문에 자주 사용
 Xml Interface Builder: XIB
 1. UIView Custom Class 지정
 2. File's Owner에서 Custom Class 지정 (자유도와 확장성이 높다. but 여러 view는 제약)
 */

/*
 View:
 - 인터페이스 빌더 UI 초기화 구문: required init?
   - 프로토콜 초기화 구문: required > 초기화 구문이 프로토콜로 되어 있음
 - 코드 UI 초기화 구문: override init
 */
protocol A {
    func example()
    init()
}
class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.backgroundColor = .lightGray
        
        self.addSubview(view)
        
        // 카드 뷰를 인터페이스 빌더 기반으로 만들고, 레이아웃도 설정했는데 false가 아닌 true로 나온다.
        // true이기에 오토레이아웃 적용이 되는 관점보다 오토리사이징이 네부적으로 constraints 처리
        print(view.translatesAutoresizingMaskIntoConstraints)
    }
    
}
