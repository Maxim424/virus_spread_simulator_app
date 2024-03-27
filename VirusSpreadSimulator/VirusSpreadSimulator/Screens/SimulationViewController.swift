//
//  SimulationViewController.swift
//  VirusSpreadSimulator
//

import UIKit

class SimulationViewController: UIViewController {
    
    // MARK: - Properties.
    
    var healthyCount: Int = 0
    var infectedCount: Int = 0
    var groupSize: Int = 100
    var infectionFactor: Int = 3
    var updateInterval: TimeInterval = 1
    var timer: Timer?
    var people: [Person] = []
    let peopleAccessQueue = DispatchQueue(label: "peopleAccess", attributes: .concurrent)
    
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
        healthyCount = groupSize
        infectedCount = 0
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
        let concurrentQueue = DispatchQueue(label: "simulation", attributes: .concurrent)
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        peopleAccessQueue.async(flags: .barrier) {
            for i in 0..<self.people.count {
                if self.people[i].status == .infected && self.people[i].canInfect {
                    concurrentQueue.async(group: group) {
                        semaphore.wait()
                        let neighbors = self.findNeighbors(personIndex: i)
                        self.infectNeighbors(neighbors: neighbors)
                        semaphore.signal()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            self.updateLabels()
        }
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
        peopleAccessQueue.async(flags: .barrier) {
            for index in neighbors {
                if self.people[index].status == .healthy {
                    self.people[index].status = .infected
                }
            }
            let indexPaths = neighbors.map { IndexPath(item: $0, section: 0) }
            DispatchQueue.main.async { self.simulationView.reloadItems(at: indexPaths) }
        }
    }
    
    func calculateStatistics() {
        healthyCount = people.filter { $0.status == .healthy }.count
        infectedCount = people.filter { $0.status == .infected }.count
    }
    
    func updateLabels() {
        calculateStatistics()
        toolbarItems?[0].title = "Здоровые: \(healthyCount)"
        toolbarItems?[2].title = "Зараженные: \(infectedCount)"
        if healthyCount == 0 {
            print(people)
        }
    }
    
    @objc
    func refreshPage() {
        timer?.invalidate()
        initializeSimulation()
        updateLabels()
    }
    
}

extension SimulationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        people[indexPath.item].status = .infected
        simulationView.reloadItems(at: [indexPath])
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


