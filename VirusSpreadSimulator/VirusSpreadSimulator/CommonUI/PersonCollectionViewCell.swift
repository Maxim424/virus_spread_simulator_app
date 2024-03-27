//
//  PersonCollectionViewCell.swift
//  VirusSpreadSimulator
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "PersonCell"
    
    let personView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        contentView.addSubview(personView)
        personView.pin(to: contentView)
    }
    
    // MARK: - Configuration
    
    func configure(with person: Person) {
        personView.backgroundColor = (person.status == .healthy) ? .green : .red
    }
    
    // MARK: - Cell Highlighting
    
    override var isHighlighted: Bool {
        didSet {
            personView.alpha = isHighlighted ? 0.5 : 1.0
        }
    }
}
