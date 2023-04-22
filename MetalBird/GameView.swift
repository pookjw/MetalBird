//
//  GameView.swift
//  MetalBird
//
//  Created by Jinwoo Kim on 4/16/23.
//

import SwiftUI
import MetalKit
import MetalBirdRenderer

#if os(macOS)
struct GameView: NSViewRepresentable {
    func makeNSView(context: Context) -> MTKView {
        context.coordinator.mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        let mtkView: DynamicMTKView = .init()
        let coordinator: Coordinator = .init(mtkView: mtkView)
        return coordinator
    }
}
#elseif os(iOS)
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
}
#endif
 
extension GameView {
    actor Coordinator {
        fileprivate let mtkView: DynamicMTKView
        private let renderer: GameRenderer
        private let setupTask: Task<Void, Never>
        
        init(mtkView: DynamicMTKView) {
            let renderer: GameRenderer = .init()
            let setupTask: Task<Void, Never> = .init {
                await MainActor.run {
#if os(macOS)
                    let gesture: MouseDownGestureRecognizer = .init(target: renderer, action: #selector(GameRenderer.jumpBird(_:)))
                    mtkView.addGestureRecognizer(gesture)
#elseif os(iOS)
                    let gesture: UITapGestureRecognizer = .init(target: renderer, action: #selector(GameRenderer.jumpBird(_:)))
                    mtkView.addGestureRecognizer(gesture)
#endif
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

#if os(macOS)
private final class MouseDownGestureRecognizer: NSGestureRecognizer {
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        if
            let target: AnyObject,
            let action: Selector,
            target.responds(to: action)
        {
            let _: Unmanaged<AnyObject>? = target.perform(action, with: self)
        }
    }
}
#endif
