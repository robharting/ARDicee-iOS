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
    
    var diceArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("ARWorldTrackingConfiguration.isSupported: \(ARWorldTrackingConfiguration.isSupported)")
        if ARWorldTrackingConfiguration.isSupported {
            
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            
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
    
    
    // MARK: - Dice Rendering Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = result.first {
                addDice(atLocation: hitResult)
                
            } else {
                print("diceNode is empty")
            }
            
        }
    }


    // atLocation is the external parameter and location is the internal parameter
    func addDice(atLocation location : ARHitTestResult) {
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            diceNode.position = SCNVector3(
                x: location.worldTransform.columns.3.x,
                y: location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                z: location.worldTransform.columns.3.z
            )
            
            diceArray.append(diceNode)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            roll(dice: diceNode)
        }
    }
    
    func roll(dice: SCNNode) {
        let randomX = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
        // let randomY = Double((arc4random_uniform(10) + 11)) * (Double.pi/2)
        let randomZ = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(
            x: CGFloat(randomX * 10),
            y: 0,
            z: CGFloat(randomZ * 5),
            duration: 1.5)
        )
    }
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    // shake to roll
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func RemoveAllDice(_ sender: UIBarButtonItem) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }
    
        
    // MARK: - ARSCNViewDelegateMethods
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let planeNode = createPlane(withPlane: planeAnchor)
        
        node.addChildNode(planeNode)
        
    }
    
    
    // MARK: - Plane Rendering methods
    
    // withPlane is the external parameter and planeAnchor is the internal name
    func createPlane(withPlane planeAnchor: ARPlaneAnchor) -> SCNNode {
        // your tile on the groud
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]
        
        let planeNode = SCNNode()
        
        planeNode.geometry = plane
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        // to rotate 90 degrees: -Float.pi/2
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        return planeNode
    }
    
    
    
}
