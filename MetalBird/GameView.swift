//
//  GameView.swift
//  MetalBird
//
//  Created by Jinwoo Kim on 4/16/23.
//

import SwiftUI
import MetalKit
import MetalBirdRenderer

struct GameView: UIViewRepresentable {
    func makeUIView(context: Context) -> MTKView {
        context.coordinator.mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        let mtkView: DynamicMTKView = .init()
        let coordinator: Coordinator = .init(mtkView: mtkView)
        return coordinator
    }
    
    actor Coordinator {
        fileprivate let mtkView: DynamicMTKView
        private let renderer: GameRenderer
        private let setupTask: Task<Void, Never>
        
        init(mtkView: DynamicMTKView) {
            let renderer: GameRenderer = .init()
            let setupTask: Task<Void, Never> = .init {
                await MainActor.run {
                    let gesture: UITapGestureRecognizer = .init(target: renderer, action: #selector(GameRenderer.jumpBird(_:)))
                    mtkView.addGestureRecognizer(gesture)
                }
                
                try! await renderer.setup(mtkView: mtkView)
            }
            
            self.mtkView = mtkView
            self.renderer = renderer
            self.setupTask = setupTask
        }
        
        deinit {
            setupTask.cancel()
        }
    }
}
