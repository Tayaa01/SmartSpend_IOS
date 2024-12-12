//
//  CustomVectorBackground.swift
//  SMARTSPEND
//
//  Created by yassmine zammali on 12/12/2024.
//


import SwiftUI

struct CustomVectorBackground: View {
    var body: some View {
        ZStack {
            // Main Background Shape
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 414, y: 0))
                path.addLine(to: CGPoint(x: 414, y: 261.76))
                path.addCurve(
                    to: CGPoint(x: 0, y: 261.76),
                    control1: CGPoint(x: 366, y: 287),
                    control2: CGPoint(x: 48, y: 287)
                )
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color("Color1"), Color("Color1")]),
                    startPoint: UnitPoint(x: -0.03, y: -0.05),
                    endPoint: UnitPoint(x: 0.58, y: 1.37)
                )
            )
            
            // Circular Path 1
            Path { path in
                let rect = CGRect(x: -55, y: -106, width: 212, height: 212)
                path.addEllipse(in: rect)
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0), Color.white.opacity(0.7)]),
                    startPoint: UnitPoint(x: 1.0, y: -0.12),
                    endPoint: UnitPoint(x: -0.76, y: 1.37)
                )
            )
            .opacity(0.1)
            
            // Circular Path 2
            Path { path in
                let rect = CGRect(x: 59, y: -63, width: 127, height: 127)
                path.addEllipse(in: rect)
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0), Color.white.opacity(0.7)]),
                    startPoint: UnitPoint(x: 1.0, y: -0.11),
                    endPoint: UnitPoint(x: 0.3, y: 1.12)
                )
            )
            .opacity(0.1)
            
            // Circular Path 3
            Path { path in
                let rect = CGRect(x: 127, y: -42, width: 85, height: 85)
                path.addEllipse(in: rect)
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0), Color.white.opacity(0.7)]),
                    startPoint: UnitPoint(x: 0.35, y: -0.1),
                    endPoint: UnitPoint(x: 1.1, y: 1.1)
                )
            )
            .opacity(0.1)
        }
        .frame(width: 414, height: 287)
    }
}

struct CustomVectorBackground_Previews: PreviewProvider {
    static var previews: some View {
        CustomVectorBackground()
            .previewLayout(.sizeThatFits)
    }
}
