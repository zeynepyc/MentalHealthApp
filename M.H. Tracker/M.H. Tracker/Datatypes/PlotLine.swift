//
//  PlotLine.swift
//  M.H. Tracker
//
//  Created by Rafi Pedersen on 5/1/23.
//

import SwiftUI

extension CGRect {
    func scale_x(_ x: Double, _ xlim: (Double, Double)) -> CGFloat {
        let x_min = CGFloat(xlim.0)
        let x_max = CGFloat(xlim.1)
        
        return x_min + (CGFloat(x) - x_min) * self.width / (x_max - x_min)
    }
    
    func scale_y(_ y: Double, _ ylim: (Double, Double)) -> CGFloat {
        let y_min = CGFloat(ylim.0)
        let y_max = CGFloat(ylim.1)
        
        return (1 - (y_min + (CGFloat(y) - y_min) / (y_max - y_min))) * self.height
    }
}

struct PlotLine: Shape {
    private var data: [(Double, Double)]
    private var xlim: (Double, Double)
    private var ylim: (Double, Double)
    private var n: Int
    
    init(data: [(Double, Double)], xlim: (Double, Double)? = nil, ylim: (Double, Double)? = nil) {
        if let xlim = xlim {
            self.xlim = xlim
        } else {
            let xs = data.map { $0.0 }
            self.xlim = (xs.min()!, xs.max()!)
        }
        
        if let ylim = ylim {
            self.ylim = ylim
        } else {
            let ys = data.map { $0.1 }
            self.ylim = (ys.min()!, ys.max()!)
        }
        
        self.data = data
        self.n = data.count
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            for index in data.indices {
                let (x,y) = data[index]
                let x_sc: CGFloat = rect.scale_x(x, xlim)
                let y_sc: CGFloat = rect.scale_y(y, ylim)
                
                if index == 0 {
                    path.move(to: CGPoint(x: x_sc, y: y_sc))
                } else {
                    path.addLine(to: CGPoint(x: x_sc, y: y_sc))
                }
            }
        }
    }
}
