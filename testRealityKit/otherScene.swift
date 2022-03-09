//
//  otherScene.swift
//  testRealityKit
//
//  Created by Konstantinos Vogklis on 5/3/22.
//

import Foundation


//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
//        arView.addGestureRecognizer(tap)
//
//
//
//        let anchor = AnchorEntity(plane: .horizontal,  minimumBounds: [0.2, 0.2])
//        arView.scene.addAnchor(anchor)
//
//        var cards: [Entity] = []
//        for _ in 1...4{
//            let box =  MeshResource.generateBox(width: 0.04, height: 0.002, depth: 0.04)
//
//            let metalMaterial = SimpleMaterial(color: .gray, isMetallic: true)
//            let model = ModelEntity(mesh: box, materials: [metalMaterial])
//
//            model.generateCollisionShapes(recursive: true)
//            cards.append(model)
//        }
//
//        for (index, card) in cards.enumerated(){
//            let x = Float(index % 2)
//            let z = Float(index / 2)
//            card.position = [x*0.1, 0, z*0.1]
//            anchor.addChild(card)
//        }
//
//        let boxSize: Float = 0.7
//        let occlusionBoxMesh = MeshResource.generateBox(size: boxSize)
//        let occlusionBox = ModelEntity(mesh: occlusionBoxMesh, materials: [OcclusionMaterial()])
//        occlusionBox.position.y = -boxSize/2
//        anchor.addChild(occlusionBox)
//
//        var cancellable: AnyCancellable? =  nil
//        cancellable = ModelEntity.loadModelAsync(named: "05").append(ModelEntity.loadModelAsync(named: "04")).collect().sink(receiveCompletion: {error in
//            print ("error")
//            cancellable?.cancel()
//        }, receiveValue: { entinties in
//            var objects: [ModelEntity] = []
//            for entity in entinties{
//                entity.setScale(SIMD3<Float>(0.001, 0.001, 0.001), relativeTo: anchor)
//                entity.generateCollisionShapes(recursive: true)
//                for _  in 1...2{
//                    objects.append(entity.clone(recursive: true))
//                }
//            }
//            objects.shuffle()
//            for (index, object) in objects.enumerated(){
//                cards[index].addChild(object)
//                cards[index].transform.rotation = simd_quatf(angle:.pi, axis:[1, 0, 0])
//            }
//            cancellable?.cancel()
//        })

//
//@objc func onTap(_ sender: UITapGestureRecognizer){
//    print ("tap")
//    let tapLocation = sender.location(in: arView)
//    if let card = arView.entity(at: tapLocation){
//        if card.transform.rotation.angle == .pi {
//            var flipDownTransform = card.transform
//            flipDownTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
//            card.move(to: flipDownTransform, relativeTo: card.parent, duration: 0.25, timingFunction: .easeInOut)
//        }else{
//            var flipUpTransform = card.transform
//            flipUpTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
//            card.move(to: flipUpTransform, relativeTo: card.parent, duration: 0.25, timingFunction: .easeInOut)
//
//        }
//    }
//}

