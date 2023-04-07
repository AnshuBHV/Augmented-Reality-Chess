//
//  ContentView.swift
//  AR - Summative Project
//
//  Created by Conant High on 1/23/23.
//


import SwiftUI
import RealityKit


struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}


struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let entity = Experience.Box()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        let boardModelEntity = ModelEntity()
        boardModelEntity.addChild(entity)
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        // Generate collision shapes (needed for gestures)
        boxAnchor.generateCollisionShapes(recursive: true)
        
//        // Add a collision component to the parentEntity with a rough shape and appropriate offset for the model that it contains
//        let entityBounds = entity.visualBounds(relativeTo: boardModelEntity)
//        boardModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
        
//        // Install gesture
//        let box = boxAnchor as? Entity & HasCollision
        arView.installGestures(for: boardModelEntity)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}


class CustomBox: Entity, HasModel, HasAnchoring, HasCollision {
    
    required init(color: UIColor) {
        super.init()
        self.components[ModelComponent] = ModelComponent(
            mesh: .generateBox(size: 0.1),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
