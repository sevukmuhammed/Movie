import Kingfisher
import UIKit

class MovieCell: UITableViewCell {
    // MARK: - Properties

    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Setup

    private func setupViews() {
        self.backgroundColor = .clear
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieTitleLabel)

        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            movieImageView.widthAnchor.constraint(equalToConstant: 80),

            movieTitleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 16),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            movieTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with imagePath: String?, title: String?) {
        movieTitleLabel.text = title
        guard
            let imagePath,
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w185\(imagePath)")
        else {
            return
        }
        movieImageView.kf.setImage(with: imageUrl)
    }
}
