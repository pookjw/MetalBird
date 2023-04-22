//
//  MetalBirdApp.swift
//  MetalBird
//
//  Created by Jinwoo Kim on 4/16/23.
//

import SwiftUI

@main
struct MetalBirdApp: App {
    var body: some Scene {
#if os(iOS)
        WindowGroup { 
            ContentView()
        }
#elseif os(macOS)
        Window("", id: "") {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
