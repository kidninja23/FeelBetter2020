//
//  ViewExtension.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/18/20.
//

import Foundation
import SwiftUI

extension View {
  @ViewBuilder
  func `if`<Transform: View>(
    _ condition: Bool,
    transform: (Self) -> Transform
  ) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
