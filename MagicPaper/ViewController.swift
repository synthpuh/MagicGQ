//
//  ViewController.swift
//  MagicPaper
//
//  Created by Ольга Шубина on 26.06.2020.
//  Copyright © 2020 Ольга Шубина. All rights reserved.
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pictures", bundle: Bundle.main) {
            
            configuration.trackingImages = imagesToTrack
            configuration.maximumNumberOfTrackedImages = 5
            
            print("Images successfully added")
            
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        DispatchQueue.main.async {
            
            if let imageAnchor = anchor as? ARImageAnchor {
                
                let plane = SCNPlane(width: (imageAnchor.referenceImage.physicalSize.width), height: imageAnchor.referenceImage.physicalSize.height)
                
                let planeNode = SCNNode(geometry: plane)
                
                let videoScene = self.playVideo(imageAnchor: imageAnchor)
                
                plane.firstMaterial?.diffuse.contents = videoScene
                
                planeNode.eulerAngles.x = -.pi / 2
                
                node.addChildNode(planeNode)
                
                if planeNode.isHidden == true {
                    if let imageAnchor = anchor as? ARImageAnchor {
                        self.sceneView.session.remove(anchor: imageAnchor)
                    }
                    
                }
//                } else {
//                    if !isNodeAdded {
//                        isNodeAdded = true
//                    }
//                }
                
            }
            
        }
        
        return node
        
    }
    
    func playVideo(imageAnchor: ARImageAnchor) -> SKScene {
        
        let videoScene = SKScene(size: CGSize(width: 1280, height: 720))
        
        if let name = imageAnchor.referenceImage.name {
            
            let videoNode = SKVideoNode(fileNamed: "\(name).mp4")
                    
            videoNode.play()
                                 
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
                    
            videoNode.yScale = -1.0
                    
            videoScene.addChild(videoNode)
            
        }
        
        return videoScene
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        if node.isHidden == true {
            if let imageAnchor = anchor as? ARImageAnchor {
                sceneView.session.remove(anchor: imageAnchor)
            }
        }
//        else {
//            if !isNodeAdded {
//                isNodeAdded = true
//            }
//        }
    }
    
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        if !sceneView.isNode(videoNode as! SCNNode, insideFrustumOf: sceneView.pointOfView!) {
//            videoNode.pause()
//        }
//
//    }
    
}
