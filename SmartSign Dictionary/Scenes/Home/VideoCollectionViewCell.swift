//
//  VideoCollectionViewCell.swift
//  SmartSign Dictionary
//
//  Created by Srivinayak Chaitanya Eshwa on 21/08/24.
//

import UIKit
import ConstraintKit
import Kingfisher
import YouTubeiOSPlayerHelper

final class VideoCollectionViewCell: UICollectionViewCell {
    
    private let videoPlayerView: YTPlayerView = {
        let playerView = YTPlayerView()
        playerView.setLoop(true)
        return playerView
    }()
    
    private var videoId: String?
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(videoTitleLabel)
        thumbnailImageView.pin(edges: .top(spacing: 0), .leading(spacing: 0), .trailing(spacing: 0), to: contentView)
        videoTitleLabel.pinTopToBottom(of: thumbnailImageView, withSpacing: 12)
        videoTitleLabel.pin(edges: .leading(spacing: 20), .trailing(spacing: -20), .bottom(spacing: -20), to: contentView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnImage(_:)))
        thumbnailImageView.addGestureRecognizer(tapGestureRecognizer)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    @objc private func didTapOnImage(_ sender: UITapGestureRecognizer) {
        guard let videoId else { return }
        UIView.transition(from: thumbnailImageView, to: videoPlayerView, duration: 0.3, options: [.curveEaseInOut]) { _ in
            self.videoPlayerView.pin(edges: .leading(spacing: 0), .trailing(spacing: 0), .top(spacing: 0))
            self.videoPlayerView.pinBottomToTop(of: self.videoTitleLabel, withSpacing: -12)
            self.videoPlayerView.load(withVideoId: videoId)
            self.videoPlayerView.playVideo()
        }
    }
    
    func configure(with video: Video) {
        thumbnailImageView.kf.setImage(with: URL(string: video.thumbnailURL))
        videoId = video.videoId
        videoTitleLabel.text = video.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        UIView.transition(from: videoPlayerView, to: thumbnailImageView, duration: 0.01) { _ in
            self.thumbnailImageView.pin(edges: .leading(spacing: 0), .trailing(spacing: 0), .top(spacing: 0))
            self.thumbnailImageView.pinBottomToTop(of: self.videoTitleLabel, withSpacing: -12)
        }
    }
}
