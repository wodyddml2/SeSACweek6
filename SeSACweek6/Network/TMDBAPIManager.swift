import UIKit

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {
        
        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.TMDB)&language=ko-KR"
        
        // Alamofire -> URLSession Framework -> 비동기로 request 내부적으로 코드가 짜여져있다
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                let stillArr = json["episodes"].arrayValue.map {$0["still_path"].stringValue}
                
                completionHandler(stillArr)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        // 1. 순서 보장 x, 2. 언제 끝날 지 모름 3. 차단 당할 수 있음(ex. 1초 5번 Block) => 담주 해결
      //        for item in tvList {
      //            TMDBAPIManager.shared.callRequest(item.1) { stillPath in
      //                print(stillPath)
      //            }
      //        }
        
        var posterList: [[String]] = []
     
        
        // 나중에 배울 것: async/await(iOS 13이상)
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)
            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)
                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
