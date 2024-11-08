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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            //            if !result.isEmpty {
            //                print("touched the plan")
            //            } else {
            //                print("touched somewhere else")
            //            }
            
            if let hitResult = result.first {
                //print(hitResult)
                
                // Create a new scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    
                    diceNode.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        z: hitResult.worldTransform.columns.3.z
                    )
                    
                    diceArray.append(diceNode)
                    
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                  
                    roll(dice: diceNode)
                    
                } else {
                    print("diceNode is empty")
                }
                
            }
        }
    }
    
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
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
    
    
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            print("Plane detected")
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // you tile on the groud
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
                        
            let planeNode = SCNNode()
            
            planeNode.geometry = plane
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            // to rotate 90 degrees: -Float.pi/2
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }
    
}
