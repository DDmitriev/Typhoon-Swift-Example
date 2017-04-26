////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

import Foundation

private enum SideViewState {
    case hidden
    case showing
}

open class RootViewController : UIViewController, PaperFoldViewDelegate {

    let SIDE_CONTROLLER_WIDTH : CGFloat = 245.0
    let lockQueue = DispatchQueue(label: "pf.root.lockQueue", attributes: [])
    
    fileprivate var navigator : UINavigationController!
    fileprivate var mainContentViewContainer : UIView!
    fileprivate var sideViewState : SideViewState!
    fileprivate var assembly : ApplicationAssembly!
    
    fileprivate var paperFoldView : PaperFoldView {
        get {
            return self.view as! PaperFoldView
        }
        set {
            self.view = newValue
        }
    }

    fileprivate var citiesListController : UIViewController?
    fileprivate var addCitiesController : UIViewController?
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    
    public init(mainContentViewController : UIViewController, assembly : ApplicationAssembly) {
        super.init(nibName : nil, bundle : nil)
        
        self.assembly = assembly
        self.sideViewState = SideViewState.hidden
        self.pushViewController(mainContentViewController, replaceRoot: true)
    }
        
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //-------------------------------------------------------------------------------------------
    // MARK: - Public Methods
    //-------------------------------------------------------------------------------------------

    open func pushViewController(_ controller : UIViewController) {
        self.pushViewController(controller, replaceRoot: false)
    }
    
    open func pushViewController(_ controller : UIViewController, replaceRoot : Bool) {
        
        lockQueue.sync {
            
            if (self.navigator == nil) {
                self.makeNavigationControllerWithRoot(controller)
            }
            else if (replaceRoot) {
                self.navigator.setViewControllers([controller], animated: true)
            }
            else {
                self.navigator.pushViewController(controller, animated: true)
            }
        }
    }

    open func popViewControllerAnimated(_ animated : Bool) {
        
        let lockQueue = DispatchQueue(label: "pf.root.lockQueue", attributes: [])
        lockQueue.sync {
            self.navigator.popViewController(animated: animated)
            return
        }
    }
    
    open func showCitiesListController() {
        if (self.sideViewState != SideViewState.showing) {
            self.sideViewState = SideViewState.showing
            self.citiesListController = UINavigationController(rootViewController: self.assembly.citiesListController() as! UIViewController)
            
            self.citiesListController!.view.frame = CGRect(x: 0, y: 0, width: SIDE_CONTROLLER_WIDTH, height: self.mainContentViewContainer.frame.size.height)
            
            self.paperFoldView.delegate = self
            self.paperFoldView.setLeftFoldContent(citiesListController!.view, foldCount: 5, pullFactor: 0.9)
            self.paperFoldView.setPaperFoldState(PaperFoldStateLeftUnfolded)
            self.mainContentViewContainer.setNeedsDisplay()
        }
    }
    
    open func dismissCitiesListController() {
        if (self.sideViewState != SideViewState.hidden) {
            self.sideViewState = SideViewState.hidden
            self.paperFoldView.setPaperFoldState(PaperFoldStateDefault)
            self.navigator!.topViewController!.viewWillAppear(true)
        }
    }

    open func toggleSideViewController() {
        if (self.sideViewState == SideViewState.hidden) {
            self.showCitiesListController()
        }
        else if (self.sideViewState == SideViewState.showing) {
            self.dismissCitiesListController()
        }
    }
    
    open func showAddCitiesController() {
        if (self.addCitiesController == nil) {
            self.navigator.topViewController!.view.isUserInteractionEnabled = false
            
            self.addCitiesController = UINavigationController(rootViewController: self.assembly.addCityViewController() as! UIViewController)            
            
            self.addCitiesController!.view.frame = CGRect(x: 0, y: self.view.frame.origin.y + self.view.frame.size.height, width: SIDE_CONTROLLER_WIDTH, height: self.view.frame.size.height)
            self.view.addSubview(self.addCitiesController!.view)
            
            UIView.transition(with: self.view, duration: 0.25, options: UIViewAnimationOptions(), animations: {
                
                self.addCitiesController!.view.frame = CGRect(x: 0, y: 0, width: self.SIDE_CONTROLLER_WIDTH, height: self.view.frame.size.height)
                
            }, completion: nil)
        }
    }
    
    open func dismissAddCitiesController() {
        if (self.addCitiesController != nil) {
            self.citiesListController?.viewWillAppear(true)
            UIView.transition(with: self.view, duration: 0.25, options: UIViewAnimationOptions(), animations: {
                
                self.addCitiesController!.view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.SIDE_CONTROLLER_WIDTH, height: self.view.frame.size.height)
                
            }, completion: {
                (completed) in
                
                self.addCitiesController!.view.removeFromSuperview()
                self.addCitiesController = nil
                self.citiesListController?.viewDidAppear(true)
                self.navigator.topViewController!.view.isUserInteractionEnabled = true
            })
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - PaperFoldViewDelegate
    //-------------------------------------------------------------------------------------------
    open func paperFoldView(_ paperFoldView: AnyObject!, didFoldAutomatically automated: Bool, to paperFoldState: PaperFoldState) {
        if paperFoldState.rawValue == 0 {
            self.navigator.topViewController!.viewDidAppear(true)
            
            
            let dummyView = UIView(frame: CGRect(x: 1,y: 1,width: 1,height: 1))
            self.paperFoldView.setLeftFoldContent(dummyView, foldCount: 0, pullFactor: 0)
            self.citiesListController = nil
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Overridden Methods
    //-------------------------------------------------------------------------------------------

    open override func loadView() {
        let screen = UIScreen.main.bounds
        self.paperFoldView = PaperFoldView(frame: CGRect(x: 0, y: 0, width: screen.size.width, height: screen.size.height))
        self.paperFoldView.timerStepDuration = 0.02
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        
        self.mainContentViewContainer = UIView(frame: self.paperFoldView.bounds)
        self.mainContentViewContainer.backgroundColor = UIColor.black
        self.paperFoldView.setCenterContent(self.mainContentViewContainer)
    }
    
    open override func viewWillLayoutSubviews() {
        self.mainContentViewContainer.frame = self.view.bounds
    }
    
    open override var shouldAutorotate : Bool {
        return self.navigator!.topViewController!.shouldAutorotate
    }
    
    open override func willRotate(to orientation: UIInterfaceOrientation, duration: TimeInterval) {

        self.navigator!.topViewController!.willRotate(to: orientation, duration: duration)
    }
    
    open override func didRotate(from orientation: UIInterfaceOrientation) {
        self.navigator!.topViewController!.didRotate(from: orientation)
    }

            
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private Methods
    //-------------------------------------------------------------------------------------------

    fileprivate func makeNavigationControllerWithRoot(_ root : UIViewController) {
        self.navigator = UINavigationController(rootViewController: root)
        self.navigator.view.frame = self.view.bounds
        mainContentViewContainer.addSubview(self.navigator.view)
    }
    
    
}
