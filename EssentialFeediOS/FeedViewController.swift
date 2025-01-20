//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by sam hastings on 20/01/2025.
//

import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        onViewIsAppearing = { vc in
            vc.refresh()
            // this ensures that the refresh action is added to the refreshControl the first time viewIsAppearing is invoked
            vc.refreshControl?.addTarget(vc, action: #selector(vc.refresh), for: .valueChanged)

            // This ensures that the `onViewIsAppearing` closure is triggered only the first time viewIsAppearing is invoked
            vc.onViewIsAppearing = nil
        }
        load()
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        print("viewIsAppearing")
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    @objc private func load() {
        print("load")
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func refresh() {
        print("refresh")
        refreshControl?.beginRefreshing()
    }
    
}
