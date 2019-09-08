//
//  ViewControllerTest.swift
//  MobileUsageTests
//
//  Created by Ananta Sjartuni on 8/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import XCTest
@testable import MobileUsage
class ViewControllerTest: XCTestCase {

    var mainvc: MobileUsage.ViewController!
    
    private func setUpViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        self.mainvc = storyboard.instantiateViewController(withIdentifier: "MainVCID") as? MobileUsage.ViewController //
        self.mainvc.loadView()
        self.mainvc.viewDidLoad()
        self.mainvc.viewWillAppear(true)
    }
    
    override func setUp() {
        super.setUp()
        
        self.setUpViewControllers()
    }
    
    override func tearDown() {
        mainvc = nil
        
        super.tearDown()
    }
    
    func testMainVC() {
        XCTAssertNotNil(self.mainvc, "Main VC is nil")
        //XCTAssertNotNil(self.mainvc.button, "Button is nil")
    }

}
