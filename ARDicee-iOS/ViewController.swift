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
        
        // chamferRadius is how rounded you want the corners of your box to be. Size is in meter
        let cube  = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        cube.materials = [material]
        
        let node = SCNNode()
        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        
        node.geometry = cube
        
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//        
//        // Set the scene to the view
//        sceneView.scene = scene
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
