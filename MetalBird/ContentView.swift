//
//  ContentView.swift
//  MetalBird
//
//  Created by Jinwoo Kim on 4/16/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GameView()
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
