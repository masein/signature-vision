//
//  CameraViewController+Ext.swift
//  HandPose
//
//  Created by Arsh on 3/27/23.
//  Copyright © 2023 Apple. All rights reserved.
//
import UIKit
import AVFoundation
import Vision

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        var thumbTip: CGPoint?
        var thumbIp: CGPoint?
        var thumbMp: CGPoint?
        var thumbCmc: CGPoint?
        
        var indexTip: CGPoint?
        var indexDip: CGPoint?
        var indexPip: CGPoint?
        var indexMcp: CGPoint?
        
        var middleTip: CGPoint?
        var middleDip: CGPoint?
        var middlePip: CGPoint?
        var middleMcp: CGPoint?
        
        var ringTip: CGPoint?
        var ringDip: CGPoint?
        var ringPip: CGPoint?
        var ringMcp: CGPoint?
        
        var littleTip: CGPoint?
        var littleDip: CGPoint?
        var littlePip: CGPoint?
        var littleMcp: CGPoint?
        
        var wrist: CGPoint?
        
        defer {
            DispatchQueue.main.sync {
                self.processPoints(fingers: PossibleFingers(thumb: PossibleThumb(TIP: thumbTip, IP: thumbIp, MP: thumbMp, CMC: thumbCmc),
                                                            index: PossibleFinger(TIP: indexTip, DIP: indexDip, PIP: indexPip, MCP: indexMcp),
                                                            middle: PossibleFinger(TIP: middleTip, DIP: middleDip, PIP: middlePip, MCP: middleMcp),
                                                            ring: PossibleFinger(TIP: ringTip, DIP: ringDip, PIP: ringPip, MCP: ringMcp),
                                                            little: PossibleFinger(TIP: littleTip, DIP: littleDip, PIP: littlePip, MCP: littleMcp),
                                                            wrist: wrist))
            }
        }

        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        do {
            // Perform VNDetectHumanHandPoseRequest
            try handler.perform([handPoseRequest])
            // Continue only when a hand was detected in the frame.
            // Since we set the maximumHandCount property of the request to 1, there will be at most one observation.
            guard let observation = handPoseRequest.results?.first else {
                return
            }
            // Get points for thumb and index finger.
            let thumbPoints = try observation.recognizedPoints(.thumb)
            let indexFingerPoints = try observation.recognizedPoints(.indexFinger)
            let middleFingerPoints = try observation.recognizedPoints(.middleFinger)
            let ringFingerPoints = try observation.recognizedPoints(.ringFinger)
            let littleFingerPoints = try observation.recognizedPoints(.littleFinger)
            let wristPoints = try observation.recognizedPoints(.all)
            
            // Look for tip points.
            guard let thumbTipPoint = thumbPoints[.thumbTip],
                  let thumbIpPoint = thumbPoints[.thumbIP],
                  let thumbMpPoint = thumbPoints[.thumbMP],
                  let thumbCMCPoint = thumbPoints[.thumbCMC] else {
                return
            }
            
            guard let indexTipPoint = indexFingerPoints[.indexTip],
                  let indexDipPoint = indexFingerPoints[.indexDIP],
                  let indexPipPoint = indexFingerPoints[.indexPIP],
                  let indexMcpPoint = indexFingerPoints[.indexMCP] else {
                return
            }
            
            guard let middleTipPoint = middleFingerPoints[.middleTip],
                  let middleDipPoint = middleFingerPoints[.middleDIP],
                  let middlePipPoint = middleFingerPoints[.middlePIP],
                  let middleMcpPoint = middleFingerPoints[.middleMCP] else {
                return
            }
            
            guard let ringTipPoint = ringFingerPoints[.ringTip],
                  let ringDipPoint = ringFingerPoints[.ringDIP],
                  let ringPipPoint = ringFingerPoints[.ringPIP],
                  let ringMcpPoint = ringFingerPoints[.ringMCP] else {
                return
            }
            
            guard let littleTipPoint = littleFingerPoints[.littleTip],
                  let littleDipPoint = littleFingerPoints[.littleDIP],
                  let littlePipPoint = littleFingerPoints[.littlePIP],
                  let littleMcpPoint = littleFingerPoints[.littleMCP] else {
                return
            }
            
            guard let wristPoint = wristPoints[.wrist] else {
                return
            }
            
            let minimumConfidence: Float = 0.3
            // Ignore low confidence points.
            guard thumbTipPoint.confidence > minimumConfidence,
                  thumbIpPoint.confidence > minimumConfidence,
                  thumbMpPoint.confidence > minimumConfidence,
                  thumbCMCPoint.confidence > minimumConfidence else {
                return
            }
            
            guard indexTipPoint.confidence > minimumConfidence,
                  indexDipPoint.confidence > minimumConfidence,
                  indexPipPoint.confidence > minimumConfidence,
                  indexMcpPoint.confidence > minimumConfidence else {
                return
            }
            
            guard middleTipPoint.confidence > minimumConfidence,
                  middleDipPoint.confidence > minimumConfidence,
                  middlePipPoint.confidence > minimumConfidence,
                  middleMcpPoint.confidence > minimumConfidence else {
                return
            }
            
            guard ringTipPoint.confidence > minimumConfidence,
                  ringDipPoint.confidence > minimumConfidence,
                  ringPipPoint.confidence > minimumConfidence,
                  ringMcpPoint.confidence > minimumConfidence else {
                return
            }
            
            guard littleTipPoint.confidence > minimumConfidence,
                  littleDipPoint.confidence > minimumConfidence,
                  littlePipPoint.confidence > minimumConfidence,
                  littleMcpPoint.confidence > minimumConfidence else {
                return
            }
            
            guard wristPoint.confidence > minimumConfidence else {
                return
            }
            
            // Convert points from Vision coordinates to AVFoundation coordinates.
            thumbTip = CGPoint(x: thumbTipPoint.location.x, y: 1 - thumbTipPoint.location.y)
            thumbIp = CGPoint(x: thumbIpPoint.location.x, y: 1 - thumbIpPoint.location.y)
            thumbMp = CGPoint(x: thumbMpPoint.location.x, y: 1 - thumbMpPoint.location.y)
            thumbCmc = CGPoint(x: thumbCMCPoint.location.x, y: 1 - thumbCMCPoint.location.y)
            
            indexTip = CGPoint(x: indexTipPoint.location.x, y: 1 - indexTipPoint.location.y)
            indexDip = CGPoint(x: indexDipPoint.location.x, y: 1 - indexDipPoint.location.y)
            indexPip = CGPoint(x: indexPipPoint.location.x, y: 1 - indexPipPoint.location.y)
            indexMcp = CGPoint(x: indexMcpPoint.location.x, y: 1 - indexMcpPoint.location.y)
            
            middleTip = CGPoint(x: middleTipPoint.location.x, y: 1 - middleTipPoint.location.y)
            middleDip = CGPoint(x: middleDipPoint.location.x, y: 1 - middleDipPoint.location.y)
            middlePip = CGPoint(x: middlePipPoint.location.x, y: 1 - middlePipPoint.location.y)
            middleMcp = CGPoint(x: middleMcpPoint.location.x, y: 1 - middleMcpPoint.location.y)
            
            ringTip = CGPoint(x: ringTipPoint.location.x, y: 1 - ringTipPoint.location.y)
            ringDip = CGPoint(x: ringDipPoint.location.x, y: 1 - ringDipPoint.location.y)
            ringPip = CGPoint(x: ringPipPoint.location.x, y: 1 - ringPipPoint.location.y)
            ringMcp = CGPoint(x: ringMcpPoint.location.x, y: 1 - ringMcpPoint.location.y)
            
            littleTip = CGPoint(x: littleTipPoint.location.x, y: 1 - littleTipPoint.location.y)
            littleDip = CGPoint(x: littleDipPoint.location.x, y: 1 - littleDipPoint.location.y)
            littlePip = CGPoint(x: littlePipPoint.location.x, y: 1 - littlePipPoint.location.y)
            littleMcp = CGPoint(x: littleMcpPoint.location.x, y: 1 - littleMcpPoint.location.y)
            
            wrist = CGPoint(x: wristPoint.location.x, y: 1 - wristPoint.location.y)
        } catch {
            cameraFeedSession?.stopRunning()
            let error = AppError.visionError(error: error)
            DispatchQueue.main.async {
                error.displayInViewController(self)
            }
        }
    }
    
    func processPoints(fingers: PossibleFingers) {
        // Check that we have both points.
        guard let thumbTip = fingers.thumb.TIP,
              let thumbIp = fingers.thumb.IP,
              let thumbMp = fingers.thumb.MP,
              let thumbCmc = fingers.thumb.CMC,
              let indexTip = fingers.index.TIP,
              let indexDip = fingers.index.DIP,
              let indexPip = fingers.index.PIP,
              let indexMcp = fingers.index.MCP,
              let middleTip = fingers.middle.TIP,
              let middleDip = fingers.middle.DIP,
              let middlePip = fingers.middle.PIP,
              let middleMcp = fingers.middle.MCP,
              let ringTip = fingers.ring.TIP,
              let ringDip = fingers.ring.DIP,
              let ringPip = fingers.ring.PIP,
              let ringMcp = fingers.ring.MCP,
              let littleTip = fingers.little.TIP,
              let littleDip = fingers.little.DIP,
              let littlePip = fingers.little.PIP,
              let littleMcp = fingers.little.MCP,
              let wrist = fingers.wrist else {
            // If there were no observations for more than 2 seconds reset gesture processor.
            if Date().timeIntervalSince(lastObservationTimestamp) > 2 {
                gestureProcessor.reset()
            }
            cameraView.showPoints([], color: .clear)
            return
        }
        
        // Convert points from AVFoundation coordinates to UIKit coordinates.
        let previewLayer = cameraView.previewLayer
        let thumbTipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbTip)
        let thumbIpConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbIp)
        let thumbMpConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbMp)
        let thumbCmcConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: thumbCmc)
        
        let indexTipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexTip)
        let indexDipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexDip)
        let indexPipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexPip)
        let indexMcpConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: indexMcp)
        
        let middleTipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: middleTip)
        let middleDipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: middleDip)
        let middlePipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: middlePip)
        let middleMcpConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: middleMcp)
        
        let ringTipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: ringTip)
        let ringDipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: ringDip)
        let ringPipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: ringPip)
        let ringMcpConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: ringMcp)
        
        let littleTipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: littleTip)
        let littleDipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: littleDip)
        let littlePipConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: littlePip)
        let littleMcpConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: littleMcp)
        
        let wristConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: wrist)
        
        // Process new points
        let fingers = Fingers(thumb: Thumb(TIP: thumbTipConverted, IP: thumbIpConverted, MP: thumbMpConverted, CMC: thumbCmcConverted),
                              index: Finger(TIP: indexTipConverted, DIP: indexDipConverted, PIP: indexPipConverted, MCP: indexMcpConverted),
                              middle: Finger(TIP: middleTipConverted, DIP: middleDipConverted, PIP: middlePipConverted, MCP: middleMcpConverted),
                              ring: Finger(TIP: ringTipConverted, DIP: ringDipConverted, PIP: ringPipConverted, MCP: ringMcpConverted),
                              little: Finger(TIP: littleTipConverted, DIP: littleDipConverted, PIP: littlePipConverted, MCP: littleMcpConverted),
                              wrist: wristConverted)
        
        gestureProcessor.processPoints(fingers)
    }
}

extension CameraViewController: ColorOptionsDelegate {
    func didTouchUpInsideRedColor() {
        drawOverlay.strokeColor = UIColor.red.cgColor
    }
    func didTouchUpInsideBlueColor() {
        drawOverlay.strokeColor = UIColor.blue.cgColor
    }
    func didTouchUpInsideBlackColor() {
        drawOverlay.strokeColor = UIColor.black.cgColor
    }
    func didTouchUpInsideClear() {
        self.clear()
    }
}
