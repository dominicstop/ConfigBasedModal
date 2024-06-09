//
//  FontConfig.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/9/24.
//

import UIKit


// TODO: Move to `SwiftUtilities`
public struct FontConfig {

  // MARK: - Embedded Types
  //-----------------------
  
  public enum FontWidth {
    case `default`, expanded, condensed, monospace;
    
    public var symbolicTrait: UIFontDescriptor.SymbolicTraits {
      switch self {
        case .default:
          return [];
          
        case .expanded:
          return .traitExpanded;
          
        case .condensed:
          return .traitCondensed;
          
        case .monospace:
          return .traitMonoSpace;
      };
    };
  };
  
  // MARK: - Presets
  // ---------------

  public static let `default`: Self = .init(size: UIFont.systemFontSize);
  
  // MARK: - Other Static Properties
  // -------------------------------

  public static let baseFont =
    UIFont.systemFont(ofSize: UIFont.systemFontSize);
    
  // MARK: - Properties
  // ------------------
  
  public var baseFontDescriptor = Self.baseFont.fontDescriptor;
  
  public var size: CGFloat;
  public var weight: UIFont.Weight;
  
  public var symbolicTraits: UIFontDescriptor.SymbolicTraits = [];
  
  // MARK: - Init
  // ------------
  
  public init(
    baseFontDescriptor: UIFontDescriptor = Self.baseFont.fontDescriptor,
    size: CGFloat,
    weight: UIFont.Weight = .regular,
    isBold: Bool = false,
    isItalic: Bool = false,
    width: FontWidth = .default
  ) {
    self.baseFontDescriptor = baseFontDescriptor;
    self.size = size;
    self.weight = weight;
    
    if isBold {
      self.symbolicTraits = self.symbolicTraits.union(.traitBold);
    };
    
    if isItalic {
      self.symbolicTraits = self.symbolicTraits.union(.traitItalic);
    };
    
    self.symbolicTraits = self.symbolicTraits.union(width.symbolicTrait);
  };
  
  public init(
    baseFontDescriptor: UIFontDescriptor = Self.baseFont.fontDescriptor,
    size: CGFloat,
    weight: UIFont.Weight,
    symbolicTraits: UIFontDescriptor.SymbolicTraits
  ) {
    self.baseFontDescriptor = baseFontDescriptor;
    self.size = size;
    self.weight = weight;
    self.symbolicTraits = symbolicTraits;
  };
  
  // MARK: - Functions
  // -----------------
  
  public func makeFontDescriptor() -> UIFontDescriptor {
    var descriptor = self.baseFontDescriptor;
    
    var attributes = descriptor.fontAttributes;
    attributes[.size] = self.size;
    
    var traits = attributes[.traits] as? [UIFontDescriptor.TraitKey: Any] ?? [:];
    traits[.weight] = self.weight;
    
    attributes[.traits] = traits;
    descriptor = descriptor.addingAttributes(attributes);
    
    if let nextDescriptor = descriptor.withSymbolicTraits(self.symbolicTraits) {
      descriptor = nextDescriptor;
    };
    
    return descriptor;
  };
  
  public func makeFont() -> UIFont {
    let fontDesc = self.makeFontDescriptor();
    return UIFont(descriptor: fontDesc, size: 0);
  };
};
