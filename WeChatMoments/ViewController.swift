//
//  ViewController.swift
//  WeChatMoments
//
//  Created by rainedAllNight on 2019/11/21.
//  Copyright © 2019 luowei. All rights reserved.
//

import UIKit
import ESPullToRefresh
import Kingfisher

struct PagingItem {
    static let pageSize = 5
    var currentPage = 0
    var currentIndex = 0
    
    mutating func reset() {
        currentPage = 0
        currentIndex = 0
    }
    
    mutating func next() {
        currentPage += 1
        currentIndex += PagingItem.pageSize
    }
}

enum CellIdentifier: String, CellIDable {
    case header = "TweetHeaderTableViewCell"
    case photo = "TweetPhotoTableViewCell"
    case comment = "TweetCommentTableViewCell"
}

let WCMonmentNavigationBarColor: UIColor = UIColor.init(displayP3Red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1.0)

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    private var userModel: UserModel?
    private var tweets = [TweetModel]()
    private var sections = [WCSection]()
    private var refreshSections = [WCSection]()
    private var pagingItem = PagingItem()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWithCachedData()
        fetchUserInfo()
        addRefresh()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    // MARK: - Request
    
    private func fetchUserInfo() {
        WCHttpManager<ApiMonment, UserModel>.requestModel(.fetchUserProfileInfo, success: { (user) in
            self.updateHeaderView(user)
            WCMonmentCacheManager.save(.monmentUserProfile(user))
        }) { (error) in
            // do some thing
        }
    }
    
    private func fetchTweets() {
        WCHttpManager<ApiMonment, TweetModel>.requestModelList(.fetchTweets, success: { (tweets) in
            self.sections.removeAll()
            self.configureSections(tweets)
            self.tableView.reloadData()
            self.tableView.header?.stopRefreshing()
            WCMonmentCacheManager.save(.monmentTweets(tweets))
        }) { (error) in
            self.tableView.header?.stopRefreshing()
            // do some thing
        }
    }
    
    private func initWithCachedData() {
        if let user: UserModel = WCMonmentCacheManager.getCache(.monmentUserProfile(nil)) {
            updateHeaderView(user)
        }
        
        if let tweets: [TweetModel] = WCMonmentCacheManager.getCache(.monmentTweets(nil)) {
            self.configureSections(tweets)
            tableView.reloadData()
        }
    }
    
    // MARK: - UI Set
    
    private func updateHeaderView(_ user: UserModel) {
        avatarImageView.kf.setImage(with: URL(string: user.avatar), options: [KingfisherOptionsInfoItem.processor(RoundCornerImageProcessor(cornerRadius: 4, targetSize: avatarImageView.bounds.size))])
        profileImageView.kf.setImage(with: URL(string: user.profileImage ?? ""))
        nickNameLabel.text = user.nick
    }
    
    
    // MARK: - Private method
    
    private func addRefresh() {
        let header = WCRefreshHeaderAnimator(frame: CGRect.zero)
        let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        tableView.es.addPullToRefresh(animator: header) { [unowned self] in
            self.tableView.es.resetNoMoreData()
            self.pagingItem.reset()
            self.fetchTweets()
        }
        tableView.es.addInfiniteScrolling(animator: footer) { [unowned self] in
            self.pagingItem.next()
            self.loadMore()
        }
        
        tableView.es.startPullToRefresh()
    }
    
    private func loadMore() {
        if sections.count > pagingItem.currentIndex {
            let from = (pagingItem.currentPage - 1) * PagingItem.pageSize
            refreshSections.append(contentsOf: sections[from...pagingItem.currentIndex - 1])
        } else {
            refreshSections = self.sections
        }
        tableView.reloadData()
        tableView.footer?.stopRefreshing()
        if refreshSections.count >= sections.count {
            tableView.footer?.noticeNoMoreData()
        }
    }
    
    private func configureSections(_ tweets: [TweetModel]) {
        guard !tweets.isEmpty else { return }
        for tweet in tweets {
            guard let _ = tweet.sender else {
                continue
            }
            var section = WCSection()
            let headerRow = WCRow(cellIdentifier: CellIdentifier.header, data: tweet)
            section.rows.append(headerRow)
            
            if let images = tweet.images, !images.isEmpty {
                let photoRow = WCRow(cellIdentifier: CellIdentifier.photo, data: images)
                section.rows.append(photoRow)
            }
            
            if let comments = tweet.comments, !comments.isEmpty {
                let commentRow = WCRow(cellIdentifier: CellIdentifier.comment, data: comments)
                section.rows.append(commentRow)
            }
            
            self.sections.append(section)
        }
        
        configurePullRefreshData(self.sections)
    }
    
    private func configurePullRefreshData(_ sections: [WCSection]) {
        refreshSections.removeAll()
        if sections.count > PagingItem.pageSize {
            refreshSections.append(contentsOf: sections[0...PagingItem.pageSize - 1])
        } else {
            refreshSections = sections
            tableView.footer?.noticeNoMoreData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.refreshSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refreshSections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = refreshSections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier.identifier, for: indexPath)
        let data = row.data
        
        switch row.cellIdentifier {
        case CellIdentifier.header:
            let headerCell = cell as? TweetHeaderTableViewCell
            headerCell?.configureCell(data as? TweetModel)
            
        case CellIdentifier.photo:
            let photoCell = cell as? TweetPhotoTableViewCell
            photoCell?.configureCell(row)
            
        case CellIdentifier.comment:
            let commentCell = cell as? TweetCommentTableViewCell
            commentCell?.configureCell(data as? [CommentModel])
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = refreshSections[indexPath.section].rows[indexPath.row]
        if let cachedHeight = row.cachedRowHeight {
            return cachedHeight
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = refreshSections[indexPath.section].rows[indexPath.row]
        if let cachedHeight = row.cachedRowHeight {
            return cachedHeight
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        refreshSections[indexPath.section].rows[indexPath.row].cachedRowHeight = cell.bounds.size.height
    }
}

extension ViewController: WCNavigationControllerDelegate {
    func alphaOfNavigationBar(in navigationController: UINavigationController) -> CGFloat {
        let offsetY = tableView.contentOffset.y
        let alpha = offsetY/(310 - navigationController.navigationBar.bounds.height)
        return alpha
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.updateNavBar(with: WCMonmentNavigationBarColor)
    }
}

