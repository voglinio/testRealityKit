//
//  ViewController.swift
//  testRealityKit
//
//  Created by Konstantinos Vogklis on 24/2/22.
//

import UIKit
import RealityKit
import Combine
import SwiftUI


struct ItemResult {
    let id = UUID()
    let name: String
}

extension float4x4 {
    var forward: SIMD3<Float> {
        normalize(SIMD3<Float>(-columns.2.x, -columns.2.y, -columns.2.z))
    }
}

 extension Entity {
    /// Billboards the entity to the targetPosition which should be provided in world space.
    func billboard(targetPosition: SIMD3<Float>) {
        look(at: targetPosition, from: position(relativeTo: nil), relativeTo: nil)
        //print ("look")
    }
 }


class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    var userDefaults: UserDefaults!
    var items: [String] = ["row1", "row2", "row3", "row4", "boat", "sail"]
    var boatAnchor : Experience.Boat!
    var poi: Entity!
    var ticks: UInt!
    
    var sceneEventsUpdateSubscription: Cancellable!

    
    var inventoryView: UIView?
    var targetView: UIImageView?
    var targetFrame = CGRect(x: Int(UIScreen.main.bounds.width)/2-Int(64/2), y: Int(UIScreen.main.bounds.height)/2-Int(64/2), width:  64, height: 64)
    
    var frame = CGRect(x: 0, y: UIScreen.main.bounds.height-200, width:  UIScreen.main.bounds.width, height: 200)

    struct ContentView : View {
        
        var userDefs: UserDefaults!
        var results = [ItemResult]()
        var items: [String]!

        init(userDefaults: UserDefaults, items: [String]) {
            self.userDefs = userDefaults
            self.items = items
            for item in self.items{
                let hasItem = userDefaults.bool(forKey: item)
                if  hasItem == true {
                    results.append(ItemResult(name : item))
                }
            }
        }
        var body: some View {
            List{
                VStack() {
                    ForEach(self.results, id: \.id) { result in
                        HStack(alignment: .center){
                            Image(result.name).resizable().frame(width: 32, height: 32)
                            Text("\(result.name)")

                        }
                    Divider().background(Color.green)

                    }

                }
            }
        }
    }

    func updateScene(){
        if poi == nil{
            poi = boatAnchor.findEntity(named: "poi")
        }
        poi!.billboard(targetPosition: arView.cameraTransform.translation)
        //print (arView.cameraTransform.translation, arView.center)
        ticks = ticks + 1
        if ticks % 80 == 0 && targetView != nil {
            print (arView.cameraTransform.translation, arView.center)
            targetView!.frame.size.height = targetView!.frame.height*1.2
            targetView!.frame.size.width = targetView!.frame.width*1.2
            targetView!.center.x  =  CGFloat(Float(UIScreen.main.bounds.width)/2-Float(targetView!.frame.size.width/2))
            targetView!.center.y  =  CGFloat(Float(UIScreen.main.bounds.height)/2-Float(targetView!.frame.size.height/2))
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inventoryView = nil
        targetView = nil
        poi = nil
        ticks = 0

        userDefaults = UserDefaults.standard
        
//        for item in items{
//            userDefaults.removeObject(forKey: item)
//        }
//        for item in items{
//            let hasItem = userDefaults.bool(forKey: item)
//            print (item, hasItem)
//        }
      
        // Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        boatAnchor = try! Experience.loadBoat()
    
        // Add the box anchor to the scene
        arView.scene.anchors.append(boatAnchor)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        tap.numberOfTapsRequired = 2
        arView.addGestureRecognizer(tap)
        
       
        //arView.scene.subscribe(to: SceneEvents.Update.self) { [self] _ in
         //   poi!.billboard(targetPosition: arView.cameraTransform.translation)
        //}
        
        boatAnchor.actions.boat.onAction =  handleClickBoat(_entity:)
        boatAnchor.actions.sail.onAction =  handleClickSail(_entity:)
        boatAnchor.actions.row1.onAction =  handleClickRow1(_entity:)
        boatAnchor.actions.row2.onAction =  handleClickRow2(_entity:)
        boatAnchor.actions.row3.onAction =  handleClickRow3(_entity:)

        boatAnchor.actions.startScene.onAction = sceneStarted(_entity:)

        for action in boatAnchor.actions.allActions{
            print (action.identifier)
        }
        
        sceneEventsUpdateSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { [unowned self] (_) in
            self.updateScene()
         }
        
    }
    

    
    func sceneStarted(_entity: Entity?){
        //guard let entity = entity else {return}
        //Do something with entity
        print("Scene started")
        
        //var poi = boatAnchor.findEntity(named: "poi")
        //poi?.transform.translation =  cameraOnMe(sceneEntity: (boatAnchor.scene?.anchors.first)!)
        
        
        // Check if boat is already taken
        if userDefaults.bool(forKey: "boat") == false{
            boatAnchor.notifications.boat.post()
        }
    
        if userDefaults.bool(forKey: "sail") == false{
            boatAnchor.notifications.sail.post()
        }
        
        if userDefaults.bool(forKey: "row1") == false{
            boatAnchor.notifications.row1.post()
        }
        if userDefaults.bool(forKey: "row2") == false{
            boatAnchor.notifications.row2.post()
        }
        if userDefaults.bool(forKey: "row3") == false{
            boatAnchor.notifications.row3.post()
        }
    }
    
    func handleClickBoat(_entity: Entity?){
        //guard let entity = entity else {return}
        //Do something with entity
        print("selected  boat")
        userDefaults.set(true, forKey: "boat")
    }
    
    
    func handleClickSail(_entity: Entity?){
        //guard let entity = entity else {return}
        //Do something with entity
        print("selected  sail")
        userDefaults.set(true, forKey: "sail")
    }
    
    func handleClickRow1(_entity: Entity?){
        //guard let entity = entity else {return}
        //Do something with entity
        print("selected  row1")
        userDefaults.set(true, forKey: "row1")
    }
    func handleClickRow2(_entity: Entity?){
        //guard let entity = entity else {return}
        //Do something with entity
        print("selected  row2")
        userDefaults.set(true, forKey: "row2")
    }
    func handleClickRow3(_entity: Entity?){
        //guard let entity = entity else {return}
        //Do something with entity
        print("selected  row3")
        userDefaults.set(true, forKey: "row3")
    }
    func handleClickRow4(_entity: Entity?){
        //guard let entity = entity else {return}
        //Do something with entity
        print("selected  row4")
        userDefaults.set(true, forKey: "row4")
    }
        
    @objc func onTap(_ sender: UITapGestureRecognizer){
        print ("tap")
        if targetView == nil {
            targetView = UIImageView(frame: targetFrame)
            targetView!.backgroundColor = UIColor.clear
            let catImage = UIImage(named: "target.png")
            targetView!.contentMode = UIView.ContentMode.scaleAspectFit
            targetView!.image = catImage
            view.addSubview(targetView!)

        }
        if inventoryView == nil{
            inventoryView = UIView(frame: frame)
            inventoryView!.backgroundColor = UIColor.blue
            
          
            let child = UIHostingController(rootView: ContentView(userDefaults: userDefaults, items: items))
            //var parent = UIViewController()
            child.view.translatesAutoresizingMaskIntoConstraints = false
            child.view.frame = inventoryView!.bounds
            // First, add the view of the child to the view of the parent
            inventoryView!.addSubview(child.view)
            // Then, add the child to the parent
            
            
            view.addSubview(inventoryView!)
        }else{
            inventoryView?.removeFromSuperview()
            inventoryView = nil
        }

    }
    
}
