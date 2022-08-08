import UIKit

//import Alamofire
import SwiftyJSON


// 1. html tag <> </> 기능 활용
// 2. 문자열 대체 메서드

/*
 TableView automaticDimension
 - 컨텐츠 양에 따라서 셀 높이가 자유롭게
 - 조건: 레이블 numberOfLines = 0
 - 조건: tableView 셀 높이 고정x
 - 조건: 레이아웃 잘 잡아야함.
 */
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var blogList: [String] = []
    var cafeList: [String] = []
    var isExpanded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension // 모든 섹션의 셀에 대해서 유동적
        
        searchBlog()
        
    }

    func searchBlog() {
        KakaoAPIManager.shared.callRequest(.blog, "고기") { json in
            
            
            
            for item in json["documents"].arrayValue {
                
                self.blogList.append( item["contents"].stringValue)
            }
            
            self.searchCafe()
        }
    }
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(.cafe, "고기") { json in
            
            for item in json["documents"].arrayValue {
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                self.cafeList.append(value)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        isExpanded = !isExpanded
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoCell", for: indexPath) as? KakaoCell else {return UITableViewCell()}
        cell.testLabel.numberOfLines = isExpanded ? 2 : 0
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색 결과" : "카페 검색 결과"
    }
}

class KakaoCell: UITableViewCell {
    @IBOutlet weak var testLabel: UILabel!
    
}
