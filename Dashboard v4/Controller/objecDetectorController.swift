import UIKit
import Vision
import AVFoundation
import CoreMedia
import VideoToolbox
import SwiftSocket

protocol AreaDetector {
    func areaChanged(area: Int)
}


class objecDetectorController: UIViewController, UIGestureRecognizerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var videoPreview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
        
    }()
    
    var delegate: AreaDetector?
    
    var timeLabel =  UILabel()
    
    let yolo = YOLO()
    
    var videoCapture: VideoCapture!
    var request: VNCoreMLRequest!
    var startTimes: [CFTimeInterval] = []
    
    var boundingBoxes = [BoundingBox]()
    var colors: [UIColor] = []
    
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    let semaphore = DispatchSemaphore(value: 2)
    
    
    var client: TCPClient!
    
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(connect), for: .touchUpInside)
        return button
    }()
    
    let coverContainer: UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
        
        
    }()
    
    var first = true
    
    @objc func connect() {
        print("hey")
        if first {
            
            switch client.connect(timeout: 1) {
            case .success:
                let alert = UIAlertController(title: "Connected", message: nil, preferredStyle: .alert)
                print("horford")
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                switch client.send(string: "0") {
                case .success:
                    guard let data = client.read(1024*10) else { return }
                    
                    if let response = String(bytes: data, encoding: .utf8) {
                        print(response)
                    }
                case .failure(let error):
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
            first = false
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoPreview)
        //        view.addSubview(sendButton)
        view.addSubview(coverContainer)
        
        
        view.bringSubview(toFront: sendButton)
        view.layer.zPosition = 1
        NSLayoutConstraint.activate([
            videoPreview.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            videoPreview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            videoPreview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            videoPreview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            coverContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            coverContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            coverContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            coverContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ])
        coverContainer.backgroundColor = UIColor.clear
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.connect))
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 2
        self.coverContainer.addGestureRecognizer(tapGR)
        
        //        NSLayoutConstraint.activate([
        //            sendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
        //            sendButton.heightAnchor.constraint(equalToConstant: 100),
        //            sendButton.widthAnchor.constraint(equalToConstant: 100),
        //            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)
        //            ])
        //
        //sendButton.setTitleColor(UIColor.white, for: .normal)
        
        sendButton.setTitle("Connect", for: .normal)
        view.bringSubview(toFront: sendButton)
        sendButton.layer.zPosition = 1
        
        timeLabel.text = ""
        
        setUpBoundingBoxes()
        setUpVision()
        setUpCamera()
        
        frameCapturingStartTime = CACurrentMediaTime()
        
        
        client = TCPClient(address: "192.168.20.1", port: 32623)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    // MARK: - Initialization
    
    func setUpBoundingBoxes() {
        for _ in 0..<YOLO.maxBoundingBoxes {
            boundingBoxes.append(BoundingBox())
        }
        
        // Make colors for the bounding boxes. There is one color for each class,
        // 80 classes in total.
        for r: CGFloat in [0.2, 0.4, 0.6, 0.85, 1.0] {
            for g: CGFloat in [0.6, 0.7, 0.8, 0.9] {
                for b: CGFloat in [0.6, 0.7, 0.8, 1.0] {
                    let color = UIColor(red: r, green: g, blue: b, alpha: 1)
                    colors.append(color)
                }
            }
        }
    }
    
    func setUpVision() {
        guard let visionModel = try? VNCoreMLModel(for: yolo.model.model) else {
            print("Error: could not create Vision model")
            return
        }
        
        request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
        
        // NOTE: If you choose another crop/scale option, then you must also
        // change how the BoundingBox objects get scaled when they are drawn.
        // Currently they assume the full input image is used.
        request.imageCropAndScaleOption = .scaleFill
    }
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        videoCapture.setUp(sessionPreset: AVCaptureSession.Preset.vga640x480) { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // Add the bounding box layers to the UI, on top of the video preview.
                for box in self.boundingBoxes {
                    box.addToLayer(self.videoPreview.layer)
                }
                
                // Once everything is set up, we can start capturing live video.
                self.videoCapture.start()
            }
        }
    }
    
    // MARK: - UI stuff
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    // MARK: - Doing inference
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        // Measure how long it takes to predict a single video frame. Note that
        // predict() can be called on the next frame while the previous one is
        // still being processed. Hence the need to queue up the start times.
        startTimes.append(CACurrentMediaTime())
        
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let features = observations.first?.featureValue.multiArrayValue {
            
            let boundingBoxes = yolo.computeBoundingBoxes(features: features)
            let elapsed = CACurrentMediaTime() - startTimes.remove(at: 0)
            showOnMainThread(boundingBoxes, elapsed)
        }
    }
    
    func showOnMainThread(_ boundingBoxes: [YOLO.Prediction], _ elapsed: CFTimeInterval) {
        DispatchQueue.main.async {
            
            self.show(predictions: boundingBoxes)
            
            let fps = self.measureFPS()
            self.timeLabel.text = String(format: "Elapsed %.5f seconds - %.2f FPS", elapsed, fps)
            
            self.semaphore.signal()
        }
    }
    var i = 0
    func measureFPS() -> Double {
        // Measure how many frames were actually delivered per second.
        framesDone += 1
        let frameCapturingElapsed = CACurrentMediaTime() - frameCapturingStartTime
        let currentFPSDelivered = Double(framesDone) / frameCapturingElapsed
        if frameCapturingElapsed > 1 {
            framesDone = 0
            frameCapturingStartTime = CACurrentMediaTime()
        }
        return currentFPSDelivered
    }
    
    //var iphonePredictions: [YOLO.Prediction] = []
    var area = 1
    var Ivalues: [Int] = []
    
    
    
    
    func createRect(rect: CGRect) -> CGRect {
        let width = view.bounds.width
        let height = width * 4 / 3
        let scaleX = width / CGFloat(YOLO.inputWidth)
        let scaleY = height / CGFloat(YOLO.inputHeight)
        let top = (view.bounds.height - height) / 2
        
        var newRect = rect
        newRect.origin.x *= scaleX
        newRect.origin.y *= scaleY
        newRect.origin.y += top
        newRect.size.width *= scaleX
        newRect.size.height *= scaleY
        
        return newRect
    }
    
    
    func sendArea(_ rect: CGRect) {
        
        let x = rect.midX
        let y = rect.midY
        
        if y < 600 {
            if x < 300 {
                print("Area 1")
                area = 1
            }
            else if x > 400 && x < 600 {
                print("Area 4")
                area = 4
            }
            else {
                print("Area 7")
                area = 7
            }
        }
        else if y < 750 && y > 550 {
            if x < 300 {
                print("Area 2")
                area = 2
            }
            else if x > 400 && x < 550 {
                print("Area 5")
                area = 5
            }
            else {
                print("Area 8")
                area = 8
            }
        }
        else {
            if x < 300 {
                print("Area 3")
                area = 3
            }
            else if x > 400 && x < 550 {
                print("Area 6")
                area = 6
            }
            else {
                print("Area 9")
                area = 9
            }
        }
        
        
        if area == previousArea {
            
            //            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateArea"), object: self)
            //            objecDetectorController.sarea = area
            
        }
        //print("michaellllllll")
        if area != previousArea
        {
            objecDetectorController.sarea = area
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateArea"), object: self)
            
        }
        
        previousArea = area
        
        
        
        _ = client.send(string: "\(area)")
        print("X: \(rect.midX) Y: \(rect.midY)")
    }
    
    
    
    static var sarea = 10
    var count = 0
    var previousArea = 1
    var otherpreviousarea = 0
    
    func didSet() {
        
        
        
        
    }
    
    
    
    
    func filterPredictions(_ predictions: [YOLO.Prediction]) -> (YOLO.Prediction?, Int?){
        
        var bestPrediction: YOLO.Prediction? = nil
        var bestIndex: Int? = nil
        var firstTimeFiltering = true
        
        for i in 0..<boundingBoxes.count
        {
            if i < predictions.count
            {
                let prediction = predictions[i]
                if prediction.classIndex == 67
                {
                    
                    if firstTimeFiltering == true
                    {
                        bestPrediction = prediction
                        bestIndex = i
                        firstTimeFiltering = false
                        print("hello")
                    }
                    else
                    {
                        let rect = createRect(rect: prediction.rect)
                        print("Rect Width: \(rect.size.width)")
                        print("Rect Height: \(rect.size.height)")
                        if (rect.size.width < 150 && rect.size.height < 150) && prediction.score > (bestPrediction?.score)!
                        {
                            bestPrediction = prediction
                            bestIndex = i
                        }
                    }
                }
            }
        }
        
        return (bestPrediction, bestIndex)
    }
    
    
    var bestPhonePrediction: (YOLO.Prediction?, Int?)
    
    func show(predictions: [YOLO.Prediction]) {
        bestPhonePrediction = filterPredictions(predictions)
        if bestPhonePrediction.0 == nil {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "noCoilsSeen"), object: self)
        }
        for i in 0..<boundingBoxes.count
        {
            if i < predictions.count
            {
                let prediction = predictions[i]
                let rect = createRect(rect: prediction.rect)
                
                if prediction.classIndex != 67 {
                    let label = String(format: "%@ %.1f", labels[prediction.classIndex], prediction.score * 100)
                    let color = colors[prediction.classIndex]
                    boundingBoxes[i].show(frame: rect, label: label, color: color)
                }
                else {
                    if let best = bestPhonePrediction.0
                    {
                        let label = String(format: "%@ %.1f", labels[67], best.score * 100)
                        let color = colors[67]
                        boundingBoxes[(bestPhonePrediction.1)!].show(frame: rect, label: label, color: color)
                        sendArea(rect)
                    }
                    else {
                        _ = client.send(string: "0")
                        print("becky")
                        
                    }
                    
                }
            }
            else
            {
                boundingBoxes[i].hide()
            }
        }
    }
    
}

extension objecDetectorController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // For debugging.
        //predict(image: UIImage(named: "dog416")!); return
        
        semaphore.wait()
        
        if let pixelBuffer = pixelBuffer {
            // For better throughput, perform the prediction on a background queue
            // instead of on the VideoCapture queue. We use the semaphore to block
            // the capture queue and drop frames when Core ML can't keep up.
            DispatchQueue.global().async {
                //self.predict(pixelBuffer: pixelBuffer)
                self.predictUsingVision(pixelBuffer: pixelBuffer)
            }
        }
    }
}



