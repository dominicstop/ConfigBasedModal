//
//  FontConfig.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/9/24.
//

import UIKit


// TODO: Move to `SwiftUtilities`
public struct FontConfig {
  public static let `default`: Self = .init(size: UIFont.systemFontSize);

  public static let baseFont =
    UIFont.systemFont(ofSize: UIFont.systemFontSize);
  
  public var baseFontDescriptor = Self.baseFont.fontDescriptor;
  
  public var size: CGFloat;
  public var weight: UIFont.Weight;
  
  public var isBold = false;
  public var isItalic = false;
  
  public init(
    baseFontDescriptor: UIFontDescriptor = Self.baseFont.fontDescriptor,
    size: CGFloat,
    weight: UIFont.Weight = .regular,
    isBold: Bool = false,
    isItalic: Bool = false
  ) {
    self.baseFontDescriptor = baseFontDescriptor
    self.size = size
    self.weight = weight
    self.isBold = isBold
    self.isItalic = isItalic
  }
  
  public func makeFontDescriptor() -> UIFontDescriptor {
    var descriptor = self.baseFontDescriptor;
    
    var attributes = descriptor.fontAttributes;
    attributes[.size] = self.size;
    
    var traits = attributes[.traits] as? [UIFontDescriptor.TraitKey: Any] ?? [:];
    traits[.weight] = self.weight;
    
    attributes[.traits] = traits;
    descriptor = descriptor.addingAttributes(attributes);
    
    if self.isBold,
       let descriptorNew = descriptor.withSymbolicTraits(.traitBold) {
      
      descriptor = descriptorNew;
    };
    
    if self.isItalic,
       let descriptorNew = descriptor.withSymbolicTraits(.traitItalic) {
      
      descriptor = descriptorNew;
    };
    
    return descriptor;
  };
  
  public func makeFont() -> UIFont {
    let fontDesc = self.makeFontDescriptor();
    return UIFont(descriptor: fontDesc, size: 0);
  };
};
