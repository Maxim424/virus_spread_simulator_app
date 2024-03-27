//
//  SimulationViewController.swift
//  VirusSpreadSimulator
//

import UIKit

class SimulationViewController: UIViewController {
    
    // MARK: - Properties.
    
    var groupSize: Int = 100
    var infectionFactor: Int = 3
    var updateInterval: TimeInterval = 1
    var timer: Timer?
    var people: [Person] = []
    let simulationQueue = DispatchQueue(label: "simulation", qos: .userInitiated, attributes: .concurrent)
    let statisticsQueue = DispatchQueue(label: "statistics", qos: .userInitiated)
    let peopleAccessQueue = DispatchQueue(label: "peopleAccess", qos: .userInitiated, attributes: .concurrent)
    let semaphore = DispatchSemaphore(value: 1)
    
    // MARK: - UI components.
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.5
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    let simulationView: SimulationView = {
        let view = SimulationView()
        return view
    }()
    
    // MARK: - Lifecycle functions.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        initializeSimulation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Setup UI.
    
    func setupViews() {
        setupNavBar()
        setupToolBar()
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.pin(to: view)
        scrollView.addSubview(simulationView)
        simulationView.pin(to: scrollView)
        simulationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let simulationViewHeight = view.frame.height + CGFloat(groupSize) * 1.5 - 200
        simulationView.heightAnchor.constraint(equalToConstant: simulationViewHeight).isActive = true
        simulationView.dataSource = self
        simulationView.delegate = self
        simulationView.allowsMultipleSelectionDuringEditing = true
        simulationView.isEditing = true
    }
    
    func setupNavBar() {
        title = "Моделирование"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(refreshPage)
        )
    }
    
    func setupToolBar() {
        navigationController?.isToolbarHidden = false
        let healthyItem = UIBarButtonItem(title: "Здоровые: 0", style: .plain, target: nil, action: nil)
        let infectedItem = UIBarButtonItem(title: "Зараженные: 0", style: .plain, target: nil, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [healthyItem, flexibleSpace, infectedItem]
    }
    
    // MARK: - Business logic.
    
    func initializeSimulation() {
        people = createPeople()
        simulationView.people = people
        simulationView.collectionViewLayout = RandomCollectionViewLayout(people: people)
        simulationView.setNeedsDisplay()
        timer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(updateSimulation), userInfo: nil, repeats: true)
    }
    
    func createPeople() -> [Person] {
        var peopleArray: [Person] = []
        for _ in 0..<groupSize {
            let person = Person(
                status: .healthy,
                point: .init(
                    x: CGFloat.random(in: 16...view.frame.width - 32), 
                    y: CGFloat.random(in: 25...view.frame.height + CGFloat(groupSize) * 1.5 - 225)
                ),
                canInfect: true
            )
            peopleArray.append(person)
        }
        return peopleArray
    }
    
    @objc
    func updateSimulation() {
        let group = DispatchGroup()
        peopleAccessQueue.async(flags: .barrier) { [weak self] in
            for i in 0..<(self?.people.count ?? 0) {
                if self?.people[i].status == .infected && (self?.people[i].canInfect ?? false) {
                    self?.simulationQueue.async(group: group) {
                        DispatchQueue.main.async {
                            self?.semaphore.wait()
                            let neighbors = self?.findNeighbors(personIndex: i)
                            self?.infectNeighbors(neighbors: neighbors ?? [])
                            self?.semaphore.signal()
                        }
                    }
                }
            }
        }
        updateStatistics()
    }
    
    func findNeighbors(personIndex: Int) -> [Int] {
        var neighbors: [Int] = []
        for (index, otherPerson) in people.enumerated() {
            if people[personIndex] != otherPerson && people[personIndex].distance(to: otherPerson) < 70 {
                neighbors.append(index)
            }
        }
        let uninfectedNeighbors = neighbors.filter { people[$0].status == .healthy }
        if uninfectedNeighbors.isEmpty {
            people[personIndex].canInfect = false
        }
        return Array(uninfectedNeighbors.prefix(min(infectionFactor, uninfectedNeighbors.count)))
    }
    
    func infectNeighbors(neighbors: [Int]) {
        peopleAccessQueue.async(flags: .barrier) { [weak self] in
            for index in neighbors {
                if self?.people[index].status == .healthy {
                    self?.people[index].status = .infected
                }
            }
            let indexPaths = neighbors.map { IndexPath(item: $0, section: 0) }
            DispatchQueue.main.async { self?.simulationView.reloadItems(at: indexPaths) }
        }
    }
    
    func updateStatistics() {
        statisticsQueue.async { [weak self] in
            let healthyCount = self?.people.filter { $0.status == .healthy }.count
            let infectedCount = self?.people.filter { $0.status == .infected }.count
            DispatchQueue.main.async {
                self?.toolbarItems?[0].title = "Здоровые: \(healthyCount ?? 0)"
                self?.toolbarItems?[2].title = "Зараженные: \(infectedCount ?? 0)"
            }
        }
    }
    
    @objc
    func refreshPage() {
        timer?.invalidate()
        initializeSimulation()
        updateStatistics()
    }
    
}

extension SimulationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        people[indexPath.item].status = .infected
        simulationView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        setEditing(true, animated: true)
        scrollView.isScrollEnabled = false
    }
    
    func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        print("ended")
        scrollView.isScrollEnabled = true
    }
    
}

extension SimulationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCollectionViewCell
        cell.configure(with: people[indexPath.item])
        return cell
    }
    
}

extension SimulationViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return simulationView
    }
    
}


