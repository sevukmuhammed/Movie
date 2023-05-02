import UIKit

class GenreCell: UICollectionViewCell {
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 2.0
                layer.borderColor = UIColor.gray.cgColor
            } else {
                layer.borderWidth = 0.0
            }
        }
    }

    let myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(myLabel)
        NSLayoutConstraint.activate([
            myLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            myLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            myLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
