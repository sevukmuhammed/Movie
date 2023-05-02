import UIKit

protocol SelectionHandler: AnyObject {
    func itemDidSelect()
}

class PageCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    weak var handler: SelectionHandler?
    private let tableView = UITableView()
    
    var results: [MainModels.MoviesResult]? {
        didSet {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            tableView.reloadData()
        }
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    
    private func setupTableView() {
        addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.separatorColor = .gray

        tableView.register(MovieCell.self, forCellReuseIdentifier: "movieCell")
    }

    // MARK: - UITableView
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.configure(with: results?[indexPath.row].posterPath, title: results?[indexPath.row].title)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        handler?.itemDidSelect()
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        100
    }
}
