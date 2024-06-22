//
//  ArrayWindow.swift
//  Petatet
//
//  Created by Nikita Ivanov on 21/06/2024.
//

import Foundation

//TODO: - handle fatalError
func arrayWindow<T>(array: [T], index: Int) -> [T] {
    let windowSize = 10
    let halfWindowSize = windowSize / 2

    // Ensure the index is within the bounds of the array
    guard array.indices.contains(index) else {
        fatalError("Index out of bounds")
    }

    // Calculate the start and end indices for the window
    let start = max(0, index - halfWindowSize)
    let end = min(array.count, index + halfWindowSize + 1)

    // If the calculated window is smaller than the desired size, adjust the start or end
    let actualWindowSize = end - start
    if actualWindowSize < windowSize {
        if start == 0 {
            let adjustedEnd = min(array.count, windowSize)
            return Array(array[start..<adjustedEnd])
        } else if end == array.count {
            let adjustedStart = max(0, array.count - windowSize)
            return Array(array[adjustedStart..<end])
        }
    }

    return Array(array[start..<end])
}
