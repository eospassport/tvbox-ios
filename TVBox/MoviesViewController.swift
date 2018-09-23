//
//  MoviesViewController.swift
//  TVBox
//
//  Created by Vitaly Berg on 23/09/2018.
//  Copyright © 2018 Vitaly Berg. All rights reserved.
//

import UIKit

struct Movie {
    let title: String
    let cover: URL
    let restricted: Bool
}

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var movies: [Movie] = [
        Movie(title: "The Terminator", cover: URL(string: "https://upload.wikimedia.org/wikipedia/en/thumb/7/70/Terminator1984movieposter.jpg/220px-Terminator1984movieposter.jpg")!, restricted: true),
        Movie(title: "Terminator 2", cover: URL(string: "https://images-na.ssl-images-amazon.com/images/I/51hRUw7ba6L._SY445_.jpg")!, restricted: true),
        Movie(title: "Cold War", cover: URL(string: "https://m.media-amazon.com/images/M/MV5BYjc3MTc2ZDQtZGYzNC00NGQ3LWE0NTQtODE5YjAwOTZiNTNlXkEyXkFqcGdeQXVyMTEwMTY3NDI@._V1_SY1000_CR0,0,663,1000_AL_.jpg")!, restricted: false),
        Movie(title: "Mile 22", cover: URL(string: "https://m.media-amazon.com/images/M/MV5BNzUyODk4OTkxNF5BMl5BanBnXkFtZTgwMzY0MDgzNTM@._V1_SY1000_CR0,0,674,1000_AL_.jpg")!, restricted: true),
        Movie(title: "BlaKkKlansman", cover: URL(string: "https://m.media-amazon.com/images/M/MV5BMjUyOTE1NjI0OF5BMl5BanBnXkFtZTgwMTM4ODQ5NTM@._V1_SY1000_CR0,0,674,1000_AL_.jpg")!, restricted: false)
    ]
    
    // MARK: - Collection View
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func setupCollectionView() {
        collectionView.register(MovieCell.nib, forCellWithReuseIdentifier: "movie")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movie", for: indexPath) as! MovieCell
        let movie = movies[indexPath.item]
        cell.fill(movie: movie)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let alert = UIAlertController(title: "Age restricted", message: "Confirm your age", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "By EOSPassport", style: .default, handler: { (action) in
            self.requestEOSPassport()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 370)
    }
    
    // MARK: - Passport
    
    private func requestEOSPassport() {
        var comps = URLComponents(string: "eospassport://request")!
        comps.queryItems = [
            URLQueryItem(name: "success", value: "tvbox://age/verify"),
            URLQueryItem(name: "cancel", value: "tvbox://age/cancel"),
        ]
        UIApplication.shared.open(comps.url!, options: [:])
    }
    
    // MARK: -
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var emojiView: UILabel!
    
    private func reset() {
        dimView.alpha = 0
        successView.alpha = 0
        verifyView.alpha = 1
        panelView.transform = .identity
    }
    
    private func showSuccess() {
        UIView.animate(withDuration: 0.3) {
            self.successView.alpha = 1
            self.verifyView.alpha = 0
        }
    }
    
    private var timer: Timer?
    private var index: Int = 0
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { [weak self] (timer) in
            if let index = self?.index {
                self?.emojiView.text = ["🙈", "🙉", "🙊"][index % 3]
                self?.index = index + 1
            }
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func showPanel() {
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 1
        }
    }
    
    func hidePanel() {
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0
            self.panelView.transform = CGAffineTransform(scaleX: 3, y: 3)
        }
    }
    
    func showVerification() {
        reset()
        showPanel()
        startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.showSuccess()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.hidePanel()
            }
        }
    }
    
    func startMovie() {
        
    }
    
    // MARK: - Navigation Item
    
    private func setupNavigationItem() {
        navigationItem.title = "Movies"
    }

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupCollectionView()
    }
    
    deinit {
        stopTimer()
    }
}
