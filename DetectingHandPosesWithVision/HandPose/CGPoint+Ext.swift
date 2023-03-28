//
//  CGPoint+Ext.swift
//  HandPose
//
//  Created by Arsh on 3/27/23.
//  Copyright © 2023 Apple. All rights reserved.
//
import UIKit

extension CGPoint {

    static func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
    
    func isLocatedLower(then point: CGPoint) -> CGFloat {
        return y > point.y ? 1 : 100
    }
    
    static func angleBetween(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> Double {
        let v1 = CGVector(dx: p1.x - p2.x, dy: p1.y - p2.y)
        let v2 = CGVector(dx: p3.x - p2.x, dy: p3.y - p2.y)
        
        let theta1 = atan2(v1.dy, v1.dx)
        let theta2 = atan2(v2.dy, v2.dx)
        
        let angle = theta1 - theta2
        return (Double(angle) * 180.0) / Double.pi
    }
}

