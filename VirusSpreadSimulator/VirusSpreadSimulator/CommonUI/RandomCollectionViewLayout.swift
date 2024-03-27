//
//  RandomCollectionViewLayout.swift
//  VirusSpreadSimulator
//

import UIKit

class RandomCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Properties.
    
    var people: [Person]
    
    // MARK: - Initialization.
    
    init(people: [Person]) {
        self.people = people
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cellAttributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        if people.isEmpty {
            return
        }
        guard let collectionView = collectionView else { return }
        cellAttributes.removeAll()
        let cellCount = collectionView.numberOfItems(inSection: 0)
        
        for item in 0..<cellCount {
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let randomX = people[item].point.x
            let randomY = people[item].point.y
            let size = CGSize(width: 20, height: 20)
            
            attribute.frame = CGRect(origin: CGPoint(x: randomX, y: randomY), size: size)
            cellAttributes.append(attribute)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath.item]
    }
    
    override var collectionViewContentSize: CGSize {
        return collectionView?.bounds.size ?? CGSize.zero
    }
    
}
