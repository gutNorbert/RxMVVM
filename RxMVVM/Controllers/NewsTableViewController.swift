//
//  NewsTableViewController.swift
//  RxMVVM
//
//  Created by Lightport Developer on 2020. 01. 21..
//  Copyright © 2020. Lightport Developer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        populateNews()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM == nil ? 0: self.articleListVM.articlesVM.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError()
        }

        let articleVM = self.articleListVM.articleAt(indexPath.row)

        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLbl.rx.text)
            .disposed(by: disposeBag)

        articleVM.description.asDriver(onErrorJustReturn: "")
        .drive(cell.descLbl.rx.text)
        .disposed(by: disposeBag)

        return cell
    }

    private func populateNews() {
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=hu&apiKey=1df6e375ca4b4ccfb05ee474b7e777a2")!)

        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in

                let articles = articleResponse.articles
                self.articleListVM = ArticleListViewModel(articles)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            }).disposed(by: disposeBag)
    }
}
