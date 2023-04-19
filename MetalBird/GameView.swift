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
        private let renderer: Renderer
        private let setupTask: Task<Void, Never>
        
        init(mtkView: DynamicMTKView) {
            let renderer: Renderer = .init()
            let setupTask: Task<Void, Never> = .init {
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
