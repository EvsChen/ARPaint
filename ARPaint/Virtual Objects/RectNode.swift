/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The virtual chair.
 */

import Foundation
import SceneKit

let RECT_SIZE = CGFloat(0.01)

class RectNode: SCNNode {
    
    static var boxGeo: SCNBox?
    var isSelected: Bool
    var originWidth: CGFloat?
    var originLength: CGFloat?
    
    override init() {
        print("super init get called")
        self.isSelected = false
        self.originWidth = RECT_SIZE
        self.originLength = RECT_SIZE
        super.init()
        
        if RectNode.boxGeo == nil {
            RectNode.boxGeo = SCNBox(width: RECT_SIZE, height: POINT_HEIGHT, length: RECT_SIZE, chamferRadius: 0.001)
            
            // Setup the material of the point
            let material = RectNode.boxGeo!.firstMaterial
            material?.lightingModel = SCNMaterial.LightingModel.blinn
            material?.diffuse.contents  = UIImage(named: "wood-diffuse.jpg")
            material?.normal.contents   = UIImage(named: "wood-normal.png")
            material?.specular.contents = UIImage(named: "wood-specular.jpg")
        }
        
        let object = SCNNode(geometry: RectNode.boxGeo!)
        object.transform = SCNMatrix4MakeTranslation(0.0, Float(POINT_HEIGHT) / 2.0, 0.0)
        
        self.addChildNode(object)
        
    }
    
    init(color: UIColor) {
        print("init get called")
        self.isSelected = false
        self.originWidth = RECT_SIZE
        self.originLength = RECT_SIZE
        super.init()
        
        let boxGeo = SCNBox(width: RECT_SIZE, height: POINT_HEIGHT * 2.0, length: RECT_SIZE, chamferRadius: 0.001)
        boxGeo.firstMaterial?.diffuse.contents = color
        
        let object = SCNNode(geometry: boxGeo)
        object.transform = SCNMatrix4MakeTranslation(0.0, Float(POINT_HEIGHT * 2.0) / 2.0, 0.0)
        
        self.addChildNode(object)
        
    }
    
    
    func select() -> Void {
        self.opacity = 0.5
        self.isSelected = true
        
    }
    
    func unselect() -> Void {
        self.isSelected = false
        self.opacity = 1
        self.originWidth = RectNode.boxGeo?.width
        self.originLength = RectNode.boxGeo?.length
    }
    
    
    
    func setNewHeight(newHeight: CGFloat) {
        RectNode.boxGeo?.height = newHeight
        let firstChild = self.childNodes[0]
        firstChild.transform = SCNMatrix4MakeTranslation(0.0, Float(newHeight / 2.0), 0.0)
    }
    
    func resetHeight() {
        RectNode.boxGeo?.height = POINT_HEIGHT
        let firstChild = self.childNodes[0]
        firstChild.transform = SCNMatrix4MakeTranslation(0.0, Float(POINT_HEIGHT / 2.0), 0.0)
    }
    
    func setToTime(_ time: Float) {
        let newTime = CGFloat.init(time)
        if let w = self.originWidth, let l = self.originLength {
            RectNode.boxGeo?.width = w * newTime
            RectNode.boxGeo?.length = l * newTime
        }
    }
    
    func getChildBoundingBox() -> (v1: SCNVector3, v2: SCNVector3) {
        let firstChild = self.childNodes[0]
        return (firstChild.boundingBox.max, firstChild.boundingBox.min)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
