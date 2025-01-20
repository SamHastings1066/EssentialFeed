//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by sam hastings on 16/01/2025.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
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
    
    override func viewIsAppearing(_ animated: Bool) {
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

final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_userInitiatedFeedReload_reloadsFeed() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserIniatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.simulateUserIniatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    /*
     The original name`test_viewDidLoad_showsLoadingIndicator` is no longer appropriate for this test.
     viewDidLoad lifecycle function cannot call the UIRefreshCotrol isFreshing method any more since iOS17
     Must call this method from viewIsAppearing. As such the `refresh` method that calls `isFreshing` is invoked in viewIsAppearing.
     And viewIsAppearing is itself invoked by completing an appearance transition with the following VC methods:
     - beginAppearanceTransition
     - endAppearanceTransition
     */
    func test_viewIsAppearing_showsLoadingIndicatorOnlyTheFirstTimeItIsInvoked() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        XCTAssertFalse(sut.isShowingLoadingIndicator)
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertTrue(sut.isShowingLoadingIndicator)
        
        sut.refreshControl?.endRefreshing()
        XCTAssertFalse(sut.isShowingLoadingIndicator)
        // Invoke `viewIsAppearing` a second time, this time it will not trigger a refresh
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertFalse(sut.isShowingLoadingIndicator)
        
    }
    
    func test_viewDidLoad_hidesLoadingIndicatorOnLoadCompletion() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded() // triggers lifecycle function: `loadView` and `viewDidLoad`.
        sut.replaceRefreshControlWithFakeForiOS17Support()
        XCTAssertFalse(sut.isShowingLoadingIndicator)
        
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertTrue(sut.isShowingLoadingIndicator)
        
        loader.completeFeedLoading()
        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }
    
    func test_userInitiatedFeedReload_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        
        // Need to trigger one invocation of `viewIsAppearing` in order to add the `refresh` action to the refreshControl
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        sut.simulateUserIniatedFeedReload()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }
    
    func test_userInitiatedFeedReload_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        
        // Need to trigger one invocation of `viewIsAppearing` in order to add the `refresh` action to the refreshControl
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        sut.simulateUserIniatedFeedReload()
        loader.completeFeedLoading()
        
        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }
    
    // MARK: - Helpers
    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackMemoryLeaks(sut, file: file, line: line)
        trackMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading() {
            completions[0](.success([]))
        }
        
    }
}

private extension FeedViewController {
    func simulateUserIniatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        print("beginRefreshing")
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        print("endRefreshing")
        _isRefreshing = false
    }
}

private extension FeedViewController {
    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControl()
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        refreshControl = fake
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
