//
//  ViewController.swift
//  NextReality_PlaneHitTest
//
//  Created by Ambuj Punn on 3/26/18.
//  Copyright © 2018 Next Reality. All rights reserved.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Add feature points debug options
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    private func addPlane(hitTestResult: ARHitTestResult) {
        let scene = SCNScene(named: "art.scnassets/plane_banner.scn")!
        let planeNode = scene.rootNode.childNode(withName: "planeBanner", recursively: true)
        
        planeNode?.position = SCNVector3(hitTestResult.worldTransform.columns.3.x,hitTestResult.worldTransform.columns.3.y, hitTestResult.worldTransform.columns.3.z)
        planeNode?.scale = .init(0.005, 0.005, 0.005)
        
        let bannerNode = planeNode?.childNode(withName: "banner", recursively: true)
        // Find banner material and update its diffuse contents:
        let bannerMaterial = bannerNode?.geometry?.materials.first(where: { $0.name == "logo" })
        bannerMaterial?.diffuse.contents = UIImage(named: "next_reality_logo")
        
        self.sceneView.scene.rootNode.addChildNode(planeNode!)
    }
    
    @objc func tapped(recognizer :UIGestureRecognizer) {
        // Get exact position where touch happened on screen of iPhone (2D coordinate)
        let touchPosition = recognizer.location(in: sceneView)
        
        // Conduct a hit test based on a feature point that ARKit detected to find out what 3D point this 2D coordinate relates to
        let hitTestResult = sceneView.hitTest(touchPosition, types: .featurePoint)
        
        if !hitTestResult.isEmpty {
            
            guard let hitResult = hitTestResult.first else {
                return
            }
            print(hitResult.worldTransform.columns.3)
            
            addPlane(hitTestResult: hitResult)
        }
    }
}
