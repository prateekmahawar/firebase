//
//  Created by Jake Lin on 11/23/15.
//  Copyright © 2015 Jake Lin. All rights reserved.
//

import UIKit

public protocol BlurDesignable {
  /**
   blur effect style: `ExtraLight`, `Light` or `Dark`
   */
  var blurEffectStyle: String? { get set }

  /**
   Vibrancy effect style: `ExtraLight`, `Light` or `Dark`. Once specify the Vibrancy effect style, all subviews will apply this vibrancy effect.
   */
  var vibrancyEffectStyle: String? { get set }
  var blurOpacity: CGFloat { get set }
}

public extension BlurDesignable where Self: UIView {
  /**
   configBlurEffectStyle method, should be called in layoutSubviews() method
   */
  public func configBlurEffectStyle() {
    guard let unwrappedBlurEffectStyle = blurEffectStyle, style = blurEffectStyle(from: unwrappedBlurEffectStyle) else {
      return
    }

    let blurEffectView = createVisualEffectView(UIBlurEffect(style: style))
    if let unwrappedVibrancyStyle = vibrancyEffectStyle, vibrancyStyle = blurEffectStyle(from: unwrappedVibrancyStyle) {
      let vibrancyEffectView = createVisualEffectView(UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: vibrancyStyle)))      
      subviews.forEach {
        vibrancyEffectView.contentView.addSubview($0)
      }
      blurEffectView.contentView.addSubview(vibrancyEffectView)
    }
    insertSubview(blurEffectView, atIndex: 0)
  }

  private func createVisualEffectView(effect: UIVisualEffect) -> UIVisualEffectView {
    let visualEffectView = UIVisualEffectView(effect: effect)
    visualEffectView.alpha = blurOpacity.isNaN ? 1.0 : blurOpacity
    if layer.cornerRadius > 0 {
      visualEffectView.layer.cornerRadius = layer.cornerRadius
      visualEffectView.clipsToBounds = true
    }

    visualEffectView.frame = bounds
    visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    return visualEffectView
  }

}


private extension BlurDesignable {

  func blurEffectStyle(from blurEffectStyle: String) -> UIBlurEffectStyle? {
    var style: UIBlurEffectStyle?
    guard let blurEffectStyle = BlurEffectStyle(rawValue: blurEffectStyle) else {
      return nil
    }

    switch blurEffectStyle {
    case .ExtraLight:
      style = .ExtraLight
    case .Light:
      style = .Light
    case .Dark:
      style = .Dark
    }
    return style
  }
}
