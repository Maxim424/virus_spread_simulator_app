//
//  SimulationView.swift
//  VirusSpreadSimulator
//

import UIKit

class SimulationView: UICollectionView {
    
    // MARK: - Properties
    
    var people: [Person] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        super.init(frame: frame, collectionViewLayout: flowLayout)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .systemBackground
        register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: "PersonCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCellPositions()
    }
    
    private func updateCellPositions() {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        for (index, person) in people.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            cellAttributes.frame = CGRect(x: person.point.x, y: person.point.y, width: flowLayout.itemSize.width, height: flowLayout.itemSize.height)
            collectionViewLayout.layoutAttributesForItem(at: indexPath)
        }
    }
}
