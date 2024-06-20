//
//  ViewController.swift
//  SceneKit
//
//  Created by lovehyun95 on 6/12/24.
//

import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate  {
    
    @IBOutlet var sceneView: ARSCNView!
    var independences = [String: Independence] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting =  true
        
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "independences", bundle: nil) else {
            fatalError("Couldn't load traking images")
        }
        
        configuration.detectionImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 1
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
       
        let node = SCNNode()
        guard let imageAnchor = anchor as? ARImageAnchor else { return node }
        guard let name = imageAnchor.referenceImage.name else { return nil }
        guard let independence = independences[name] else { return nil }
        
        if let imageName = imageAnchor.referenceImage.name {
            makeModel(name: imageName)
        }
        
        let backgroundPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 0.12, height: imageAnchor.referenceImage.physicalSize.height * 0.08)
        backgroundPlane.firstMaterial?.diffuse.contents = UIColor.black
        
        let backgroundNode = SCNNode(geometry: backgroundPlane)
        backgroundNode.position = SCNVector3(x: 0.27, y: -0.03, z: -0.43)
        backgroundNode.eulerAngles.y = -0.2
        
        sceneView.scene.rootNode.addChildNode(backgroundNode)
        
        let bioNode = textNode(independence.bio, font: UIFont.systemFont(ofSize: 4), maxWidth: 50)
        bioNode.position = SCNVector3(x: 0.5, y: -400, z: -0.4)
        
        let titleNode = textNode(independence.name, font: UIFont.boldSystemFont(ofSize: 10))
        titleNode.position = SCNVector3(x: 0.11, y: 0.14, z: -0.4)
        titleNode.scale = SCNVector3(x: 0.011, y: 0.011, z: 0.05)
        titleNode.eulerAngles.y = -0.2
        
        titleNode.addChildNode(bioNode)
        
        sceneView.scene.rootNode.addChildNode(titleNode)
        
        let flag = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.width / 8 * 5)
        flag.firstMaterial?.diffuse.contents = UIImage(named: independence.country)
        
        let flagNode = SCNNode(geometry: flag)
        flagNode.scale = SCNVector3(x: 0.02, y: 0.02, z: 0.05)
        flagNode.position = SCNVector3(x: 0.0, y: 0.22, z: -0.43)
        flagNode.eulerAngles.y = -0.2
        
        sceneView.scene.rootNode.addChildNode(flagNode)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.session.remove(anchor: imageAnchor)
        
        return node
    }
    
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "independences", withExtension: "json") else {
            fatalError("Unable to find JSON in bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load JSON")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedindependences = try? decoder.decode([String: Independence].self, from: data) else {
            fatalError("Unable to parse JSON.")
        }
        independences = loadedindependences
    }
    
    
    func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)
        
        text.flatness = 0.001
        text.font = font
        
        if let maxWidth = maxWidth {
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            text.isWrapped = true
        }
        
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(x: 0.8, y: 0.8, z: 0.8)
        
        return textNode
    }
    
    func makeModel(name: String) {
        if Card.Kimgu.name == name{
            guard let Scene3D = SCNScene(named: Card.Kimgu.assetLocation) else { return }
            guard let Node3D = Scene3D.rootNode.childNodes.first else { return }
            
            Node3D.eulerAngles.x = Float.pi/2
            Node3D.eulerAngles.z = Float.pi

            Node3D.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
            Node3D.position = SCNVector3(x: 0.0, y: 0.0, z: -0.4)
            sceneView.scene.rootNode.addChildNode(Node3D)
        }
    }
}

enum Card {
    case Kimgu
    
    var name: String {
        switch self {
        case .Kimgu: return "kimgu"
        }
    }
    
    var assetLocation: String {
        switch self {
        case .Kimgu:
            return "art.scnassets/kimgu.scn"
        }
    }
}
