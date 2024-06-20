# 2024-NC2-A16-SceneKit
애플 디벨로퍼 아카데미 3기 오후 마티&amp;갱 팀의 SceneKit 활용 UseCase

## 💡 About SceneKit
SceneKit은 Swift에서 제공되는 3D와 관련된 기술입니다.
SceneKit을 통해서는 3D 콘텐츠를 증강현실환경에서 렌더링하거나, 게임프로젝트에서 3D로 배경/객체를 구축할 수 있죠. 또한 3D 객체간, 환경과 객체간의 상호작용, 물리법칙을 적용할 수 있어요.
Swift-Playground에서 보이는 게임, 혹은 AR app에서 보여지는 3D캐릭터, 정보등이 SceneKit을 통해서 만들어졌습니다. 

## 🎯 What we focus on?
SceneKit을 통해서는 3D게임 / 3D콘텐츠 / 3D 애니메이션 / 물리법칙 적용 및 시뮬레이션이 가능합니다. 
SceneKit의 시작점에서, SceneKit의 기본을 맛봄과 동시에 ARKit과 어떻게 사용되는지 공부해고 싶었기 때문에 3D 콘텐츠 생성과 관련된 부분에 집중했습니다. 

## 💼 Use Case
역사적 공부를 하는 유저가, 특정 역사적 인물을 카메라로 인식하게하면, 해당 인물의 추가적인 정보를 확인할 수 있습니다. 

## 🖼️ Prototype
역사적 공부를 하는 유저가, 특정 역사적 인물을 카메라로 인식하게하면, 해당 인물의 텍스트 정보와, 국기, 3차원 흉상을 증강된 현실 위에 보여줍니다..

## 🛠️ About Code
>  **Code1** AR앱이 추적할 이미지를 설정

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



>  **Code2** 초당 frame 당 실행되는 함수에, 추적 중인 이미지가 확인되었을 때에 증강된 현실에 정보를 배치

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
       
        let node = SCNNode()
        guard let imageAnchor = anchor as? ARImageAnchor else { return node }
        guard let name = imageAnchor.referenceImage.name else { return nil }
        guard let independence = independences[name] else { return nil }
        
        if let imageName = imageAnchor.referenceImage.name {
            makeModel(on: planeNode, name: imageName)
        }
>  **Code3** 인식된 이미지의 정보를 확인하고, 일치할 때에 3D모델이 올바른 위치와 크기, 회전을 가지도록 설정 

    func makeModel(on planeNode: SCNNode, name: String) {
        if Card.Kimgu.name == name{
            guard let scene3D = SCNScene(named: Card.Kimgu.assetLocation) else { return }
            guard let node3D = scene3D.rootNode.childNodes.first else { return }
            
            node3D.eulerAngles.x = Float.pi/2
            node3D.eulerAngles.z = Float.pi

            node3D.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
            node3D.position = SCNVector3(x: 0.0, y: 0.0, z: -0.4)
            sceneView.scene.rootNode.addChildNode(node3D)
        }
    }
