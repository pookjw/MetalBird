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
        let mtkView: MTKView = .init()
        let coordinator: Coordinator = .init(mtkView: mtkView)
        return coordinator
    }
    
    actor Coordinator {
        fileprivate let mtkView: MTKView
        private let renderer: Renderer = .init()
        
        init(mtkView: MTKView) {
            self.mtkView = mtkView
            
            Task { @MainActor in
                
                try! await Renderer().setup(mtkView: .init())
            }
        }
    }
}
