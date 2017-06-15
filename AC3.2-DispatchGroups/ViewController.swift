//
//  ViewController.swift
//  AC3.2-DispatchGroups
//
//  Created by Jason Gresh on 4/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var elements: [Element] = []
    let border: CGFloat = 2.0
    var rows: CGFloat = 0.0
    var spacing: CGFloat = 2.0
    var dwellTime: TimeInterval = 2.0
    var groupStacks: [Int:UIStackView] = [:]
    var i = 0
    
    // can set this to Int.max to get all elements
    let maxImages = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        // hide the main view so we can show it all at once
        self.view.isHidden = true
        
        getData()
    }
    
    public func getData() {
        APIRequestManager.manager.getData(endPoint: "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements") { (data) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options:[]),
                    
                    let elements = jsonData as? [[String:Any]] {
                    self.elements = Element.getElements(from: elements)

                    let dispatchGroup = DispatchGroup()

                    for element in self.elements {
                        // throttle
                        self.i += 1
                        if self.i > self.maxImages {
                            break
                        }
                        
                        let imageView = UIImageView()

                        DispatchQueue.main.async {
                            // the group in groupStack is the elemental group
                            // nothing to do with a dispatch group
                            let groupStack: UIStackView
                            
                            // see if the elmeent group was created yet
                            if let stack = self.groupStacks[element.group] {
                                groupStack = stack
                            }
                            // if not, make a new one
                            else {
                                let stack = UIStackView()
                                stack.translatesAutoresizingMaskIntoConstraints = false
                                stack.axis = .vertical
                                stack.distribution = .equalSpacing
                                stack.spacing = self.spacing
                                self.rowStack.addArrangedSubview(stack)
                                groupStack = stack
                                self.groupStacks[element.group] = stack
                            }
                            
                            imageView.translatesAutoresizingMaskIntoConstraints = false
                            imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
                            groupStack.addArrangedSubview(imageView)
                        }
                        
                        print("Requesting", element.number, element.symbol, element.urlString)
                        
                        // marks the initiation of a data call
                        dispatchGroup.enter()
                        APIRequestManager.manager.getImage(endpoint: element.urlString) { (image) in
                            if let image = image {
                                print("Receiving", element.number, element.symbol, element.urlString)
                                
                                DispatchQueue.main.async {
                                    imageView.image = image
                                }
                            }
                            
                            // marks the completion of a data call
                            dispatchGroup.leave()
                        }
                    }
                    
                    // note this is outside the main loop of image requests
                    dispatchGroup.wait()
                    
                    DispatchQueue.main.async {
                        self.view.isHidden = false
                    }
                }
                
            }
        }
    }
    
    func setupView() {
        view.addSubview(rowStack)
        
        [rowStack.topAnchor.constraint(equalTo: view.topAnchor, constant: border),
         rowStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -border),
         rowStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: border),
         rowStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -border)].forEach { $0.isActive = true }
        
        // this is needed because we need to calculate against the adjusted size of the view
        view.layoutIfNeeded()
    }
    
    lazy var rowStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 2
        return stack
    }()
}

