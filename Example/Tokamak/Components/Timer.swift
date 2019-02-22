//
//  Timer.swift
//  Tokamak_Example
//
//  Created by Max Desiatov on 17/02/2019.
//  Copyright © 2019 Max Desiatov. All rights reserved.
//

import Foundation
import Tokamak

struct TimerCounter: LeafComponent {
  typealias Props = Null

  static func render(props: Null, hooks: Hooks) -> AnyNode {
    let count = hooks.state(0)
    let timer = hooks.ref(type: Timer.self)
    let interval = hooks.state(1.0)

    hooks.effect(interval.value) { () -> () -> () in
      timer.value = Timer.scheduledTimer(
        withTimeInterval: interval.value,
        repeats: true
      ) { _ in
        count.set { $0 + 1 }
      }
      return {
        timer.value?.invalidate()
      }
    }

    return StackView.node(
      .init(
        alignment: .center,
        axis: .vertical,
        distribution: .fillEqually,
        Edges.equal(to: .safeArea)
      ), [
        Label.node(
          .init(alignment: .center),
          "Adjust timer interval in seconds: \(interval.value)"
        ),
        Stepper.node(
          .init(
            minimumValue: 1.0,
            value: interval.value,
            valueHandler: Handler(interval.set)
          )
        ),
        Label.node(
          .init(alignment: .center),
          "\(count.value) second\(count.value == 1 ? "" : "s") passed"
        ),
      ]
    )
  }
}