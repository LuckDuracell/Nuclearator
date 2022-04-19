//
//  Background.swift
//  Nuclear Bomb Simulator
//
//  Created by Luke Drushell on 4/15/22.
//

import SwiftUI

struct Background: View {
    
    @State private var output: [coordinates] = []
    
    var body: some View {
        ZStack {
            Color.gray
                .edgesIgnoringSafeArea(.all)
        ForEach(output.indices, id: \.self, content: { index in
            Text("💥")
                .font(.system(size: 275, weight: .bold, design: .rounded))
                .position(x: output[index].x, y: output[index].y)
        })
        }
        .onAppear(perform: {
            output = []
            for _ in 0...150 {
                output.append(coordinates(x: CGFloat.random(in: -50...(UIScreen.main.bounds.width * 1.3)), y: CGFloat.random(in: -50...(UIScreen.main.bounds.height * 1.3))))
            }
        })
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}

struct coordinates {
    let x: CGFloat
    let y: CGFloat
}
