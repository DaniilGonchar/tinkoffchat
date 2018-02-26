//
//  ViewController.swift
//  TinkoffChat
//
//  Created by comandante on 2/25/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("ViewController: viewDidLoad\n")
        
        
        view.backgroundColor = .red
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewController: viewWillAppear\n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewController: viewDidAppear\n")
    }
    
    override func viewWillLayoutSubviews() {
        print("ViewController: viewWillLayoutSubviews\n")
    }
    
    override func viewDidLayoutSubviews() {
        print("ViewController: viewDidLayoutSubviews\n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewController: viewWillDisappear\n")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("ViewController: viewDidDisappear\n")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

