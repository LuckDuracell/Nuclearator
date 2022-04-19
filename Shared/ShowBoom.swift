//
//  ShowBoom.swift
//  Nuclear Bomb Simulator
//
//  Created by Luke Drushell on 4/19/22.
//

import SwiftUI

struct ShowBoom: View {
    
    @State var rotation: Double = 0
    @State var explode = false
    @State var explosionSize: CGFloat = 1
    fileprivate func wiggle() {
        withAnimation {
            rotation = -20
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            withAnimation {
                rotation = 5
            }
        })
    }
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            if explode {
                Text("💥")
                    .font(.system(size: 100, weight: .bold, design: .default))
                    .onAppear(perform: {
                        withAnimation {
                            explosionSize = 3
                        }
                    })
                    .scaleEffect(explosionSize)
                    .animation(.easeOut(duration: 0.2), value: explosionSize)
            } else {
                Text("💣")
                    .font(.system(size: 100, weight: .bold, design: .default))
                    .onAppear(perform: {
                        wiggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            wiggle()
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            wiggle()
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            explode = true
                        })
                    })
                    .rotationEffect(Angle(degrees: rotation))
            }
        }
    }
}

struct ShowBoom_Previews: PreviewProvider {
    static var previews: some View {
        ShowBoom()
    }
}
