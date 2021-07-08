//
//  QRCodeScannerViewController.swift
//  eXo
//
//  Created by Wajih Benabdessalem on 6/7/2021.
//  Copyright © 2021 eXo. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController {
 
    // MARK: - Outlets .

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var topBar: UIView!
    @IBOutlet weak var squareImageView: UIImageView!
    @IBOutlet weak var infoView: DesignableView!
    
    // MARK: - Variables .
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIImageView?
    var bounds:CGRect?
    // MARK: - Constants .

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewScan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    func initViewScan() {
        messageLabel.text = "OnBoarding.Title.ScanQRCode".localized
        bounds = squareImageView.bounds
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubviewToFront(messageLabel)
            view.bringSubviewToFront(topBar)
            view.bringSubviewToFront(squareImageView)
            view.bringSubviewToFront(infoView)

            // Initialize QR Code Frame to highlight the QR Code
            qrCodeFrameView = UIImageView()
            if let qrcodeFrameView = qrCodeFrameView {
                qrcodeFrameView.image = UIImage(named: "yellowSquare")
                view.addSubview(qrcodeFrameView)
                view.bringSubviewToFront(qrcodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue anymore
            print(error)
            return
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}

extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "OnBoarding.Title.ScanQRCode".localized
            squareImageView.image = #imageLiteral(resourceName: "yellowSquare")
            squareImageView.isHidden = false
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                captureSession.stopRunning()
                squareImageView.isHidden = true
                messageLabel.text = metadataObj.stringValue
                qrCodeFrameView?.image = #imageLiteral(resourceName: "qr_code_scanner")
                UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseInOut]) {
                    self.qrCodeFrameView?.frame.size = CGSize(width: 200, height: 200)
                    self.qrCodeFrameView?.center = self.view.center
                } completion: { completed in
                    self.dismiss(animated: false) {
                        if let rootURL = metadataObj.stringValue {
                            self.postNotificationWith(key: .rootFromScanURL, info: ["rootURL" : rootURL])
                        }
                    }
                }
            }
        }
    }
}


