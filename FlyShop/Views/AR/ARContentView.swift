//
//  ARContentVIew.swift
//  FlyShop
//
//  Created by Karen Mirakyan on 6/1/20.
//  Copyright © 2020 Karen Mirakyan. All rights reserved.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ARContentView: View {

    @Environment(\.presentationMode) var presentation
    @State private var modelConfiremedForPlacement: Model?
    @ObservedObject var arViewModel: ARViewModel

    init(selectedModelName: String) {
        self.arViewModel = ARViewModel()
        self.arViewModel.productName = selectedModelName
        self.arViewModel.getAR()
        print(self.arViewModel.productName)
    }

    var body: some View {

        ZStack( alignment: .bottom ) {

            ARViewContainer(modelConfirmedForPlacement: self.$modelConfiremedForPlacement)
                .environmentObject(self.arViewModel)

            PlacementButtonsView(selectedModel: self.$arViewModel.selectedModel, modelConfiremedForPlacement: self.$modelConfiremedForPlacement)
        }.onDisappear {
            self.arViewModel.shouldDismiss.toggle()
            self.arViewModel.selectedModel = nil
            self.presentation.wrappedValue.dismiss()
        }
    }
    
}

struct ARViewContainer: UIViewRepresentable {

    @EnvironmentObject var arViewModel: ARViewModel
    @Binding var modelConfirmedForPlacement: Model?

    func makeUIView(context: Context) -> ARView {
        let arView = CustomARView(frame: .zero)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
                
        if arViewModel.shouldDismiss {
            uiView.session.pause()
            uiView.session.delegate = nil
            uiView.scene.anchors.removeAll()
            uiView.removeFromSuperview()
            context.environment.presentationMode.wrappedValue.dismiss()
            return
        }

        if let model = self.modelConfirmedForPlacement {

            if let modelEntity = model.modelEntity {
                let anchorEntity = AnchorEntity(plane: .any )

                modelEntity.setScale(SIMD3(repeating: 0.003), relativeTo: nil)
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity)
            } else {
                print("Unable to load modelEntity for - \(model.path)")
            }

            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }
}

class CustomARView: ARView {
    
    var focusSquare: FocusEntity?


    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.focusSquare = FocusEntity(on: self, style: .classic)
        self.focusSquare?.delegate = self
        self.focusSquare?.setAutoUpdate(to: true)
        self.focusSquare?.scaleEntityBasedOnDistance = true

        self.setupArView()
    }

    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupArView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic

        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }

        self.session.run(config)
    }
}

extension CustomARView: FocusEntityDelegate {
    func toTrackingState() {
        print( "tracking" )
    }

    func toInitializingState() {
        print("initializing" )
    }
}


struct PlacementButtonsView: View {

    @Binding var selectedModel: Model?
    @Binding var modelConfiremedForPlacement: Model?

    var body: some View {

        HStack {

            if self.selectedModel == nil {
                Image("loadAR")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .cornerRadius(30)
                    .padding(20)
            } else {
                Button(action: {
                    self.modelConfiremedForPlacement = self.selectedModel
                }, label: {
                    Image(systemName: "checkmark")
                        .frame(width: 60, height: 60)
                        .font(.title)
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(30)
                        .padding(20)
                })
            }
        }

    }
}


struct ARContentVIew_Previews: PreviewProvider {
    static var previews: some View {
        ARContentView(selectedModelName: "Gotiner")
    }
}
