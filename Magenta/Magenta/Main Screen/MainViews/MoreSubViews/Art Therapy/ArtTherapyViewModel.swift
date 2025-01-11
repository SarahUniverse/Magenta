//
//  ArtTherapyViewModel.swift
//  Magenta
//
//  Created by Sarah Clark on 1/11/25.
//

import SwiftUI

final class ArtTherapyViewModel: ObservableObject {
    @Published var points = [CGPoint]()
    private var timer: Timer?
    private var isPaintingComplete = false

    func startPaintingOnce() {
        guard !isPaintingComplete else { return }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updatePath()

            // Stop painting after reaching a certain point
            if self.points.count >= 100 {
                self.timer?.invalidate()
                self.isPaintingComplete = true
            }
        }
    }

    func updatePath() {
        let screenWidth = UIScreen.main.bounds.width

        let time = Date().timeIntervalSinceReferenceDate
        let xAxis = screenWidth / 2 + sin(time) * screenWidth / 4
        let yAxis = 50 + (cos(time) * 20)

        points.append(CGPoint(x: xAxis, y: yAxis))

        // Limit the number of points
        if points.count > 100 {
            points.removeFirst()
        }
    }
}
