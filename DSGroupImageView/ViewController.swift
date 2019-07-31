//
//  ViewController.swift
//  DSGroupImageView
//
//  Created by Darko Spasovski on 7/31/19.
//  Copyright © 2019 Zootch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DSGroupImageViewDataSource {

    @IBOutlet weak var groupImageView: DSGroupImageView!

    var images = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        images = ["https://randomuser.me/api/portraits/women/44.jpg","https://randomuser.me/api/portraits/women/42.jpg", "https://randomuser.me/api/portraits/men/44.jpg"]
        groupImageView.dataSource = self
        groupImageView.reloadViews()

        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.images = ["https://randomuser.me/api/portraits/women/12.jpg"]
            self.groupImageView.refreshImages()
        }

        // Do any additional setup after loading the view.
    }

    func numberOfImagesInView() -> Int {
        return images.count
    }

    func imageAt(index: Int) -> String {
        return images[index]
    }
}

