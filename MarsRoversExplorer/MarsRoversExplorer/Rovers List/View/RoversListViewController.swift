//
//  ViewController.swift
//  MarsRoversExplorer
//
//  Created by Renan Santos Soares on 03/02/20.
//  Copyright © 2020 Neo Inc. All rights reserved.
//

import UIKit

class RoversListViewController: UIViewController, AlertPresentableView {
	#warning("Change to use RoversListViewModelType and conform to AlertPresentableView")
  let viewmodel: RoversListViewModel
  var items = [RoverItemViewModel]()
  let tableView = UITableView(frame: .zero, style: .plain)
  
  init(viewmodel: RoversListViewModel) {
    self.viewmodel = viewmodel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = viewmodel.title
    
    setupNavigationBar()
    setupTableView()
    
    viewmodel.items.observe(on: self) { [weak self] items in
      self?.items = items
      self?.tableView.reloadData()
    }
		
		bindToAlerts()
  }
  
  func setupNavigationBar() {
    let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    if let navBar = navigationController?.navigationBar {
      navBar.titleTextAttributes = textAttributes
      navBar.largeTitleTextAttributes = textAttributes
      navBar.prefersLargeTitles = true
      navBar.setBackgroundImage(UIImage(), for: .default)
      navBar.shadowImage = UIImage()
			navBar.tintColor = .white
      navBar.isTranslucent = true
    }
  }
  
  func setupTableView() {
    view.addSubview(tableView)
    tableView.sizeToSuperView()
    tableView.register(RoverTableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UIScreen.main.bounds.size.width * 9 / 16
    tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
    tableView.showsVerticalScrollIndicator = false
  }
}

extension RoversListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.alpha = 0
    cell.transform = .init(translationX: 0, y: 200)
    
    UIView.animate(withDuration: 0.4, delay: 0.05 * Double(indexPath.section), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
      cell.transform = .identity
      cell.alpha = 1
    })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //is force downcast bad here?
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoverTableViewCell
    let item = items[indexPath.section]
    cell.backgroundImageView.image = UIImage(named: item.imageFileName)
    cell.titleLabel.text = item.title
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = items[indexPath.section]
    item.tapped()
  }
  
}

