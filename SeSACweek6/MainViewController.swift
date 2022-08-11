
import UIKit

import Kingfisher
/*
 awakeFromNib - 셀 UI 초기화, 재사용 매커니즘에 의해 일정 횟수 이상 호출되지 않음
 cellForItemAt
 - 재사용 될 때마다, 사용자에게 보일때마다 항상 실행
 - 화면과 데이터는 별개, indexPath.item에 대한 조건이 없다면 재사용 시 오류 발생.
 - else까지 확실하게 처리해야함
 prepareForReuse
 - 셀이 재사용 될 때 초기화 하고자 하는 값을 넣으면 오류를 해결할 수 있음. 즉, cellForRowAt에 모든 indexPath.item에 대한 조건을 작성하지 않아도 됨!
 CollectionView in TableView
 - 하나의 컬렉션 뷰나 테이블 뷰라면 문제 X
 - 복합적인 구조라면, 테이블 셀도 재사용 콜렉션 셀도 재사용이 되어야 한다. (꼬임 오류)
 */
class MainViewController: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .lightGray,  .yellow, .green]
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](5000...5006),
        [Int](51...60),
        [Int](61...70),
        [Int](71...80),
        [Int](81...90)
    ]
    
    var episodeList: [[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        
        // device width 기준
        bannerCollectionView.isPagingEnabled = true
        TMDBAPIManager.shared.requestImage { value in
            // 1. 네트워크 생성 2. 배열 생성 3. 배열 담기 4. 뷰에 표현
            self.episodeList = value

            self.mainTableView.reloadData()
//            dump(value)
        }
    }
    


}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
        
    }
    
    // 컬렉션 뷰가 둘 중에 무엇이 들어올지 모른다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        print("MainViewCotroller", #function, indexPath)
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.row]
        } else {
            cell.cardView.posterImageView.backgroundColor = .black
            cell.cardView.contentLabel.textColor = .white
//            if indexPath.item < 2 {
//            cell.cardView.posterImageView.contentMode = .scaleToFill
            cell.cardView.posterImageView.kf.setImage(with: URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])" ))
            cell.cardView.contentLabel.text = ""
//            }
//            else {
//                cell.cardView.contentLabel.text = "happy"
//            }
           
        }
        
        
        return cell
        
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
    
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    // 내부 매개변수 tableView를 통해 테이블뷰를 특정
    // 테이블 뷰 객체가 하나 일 경우에는 내부 매개변수를 활용하지 않아도 문제가 되지 않는다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        
        print("MainViewController", #function, indexPath)
        
        cell.backgroundColor = .yellow
        cell.titleLabel.text = TMDBAPIManager.shared.tvList[indexPath.section].0
        cell.contentCollectionView.backgroundColor = .lightGray
        
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.tag = indexPath.section // uiview tag
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        cell.contentCollectionView.reloadData() // index 오류 해결 가능
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
