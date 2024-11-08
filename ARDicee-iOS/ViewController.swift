//
//  ViewController.swift
//  ARDicee-iOS
//
//  Created by Harting, R.P.G. (Rob) on 08/11/2024.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        // chamferRadius is how rounded you want the corners of your box to be. Size is in meter
////        let cube  = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        
//        let sphere = SCNSphere(radius: 0.2)
//        
//        let material = SCNMaterial()
////        material.diffuse.contents = UIColor.red
//        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
//        
////        cube.materials = [material]
//        sphere.materials = [material]
//        
//        let node = SCNNode()
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
//        
////        node.geometry = cube
//        node.geometry = sphere
//        
//        sceneView.scene.rootNode.addChildNode(node)
        
        
        
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
                        
            sceneView.scene.rootNode.addChildNode(diceNode)
        } else {
            print("diceNode is empty")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("ARWorldTrackingConfiguration.isSupported: \(ARWorldTrackingConfiguration.isSupported)")
        if ARWorldTrackingConfiguration.isSupported {
            
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
            
            // Run the view's session
            sceneView.session.run(configuration)
        } else {
            print("sorry no ARWorldTracking for you")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
}
