//
//  CardConfig.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/9/24.
//

import UIKit


public struct CardConfig {

  // MARK: - Properties
  // ------------------

  public var title: String;
  public var subtitle: String?;
  public var desc: [AttributedStringConfig];
  public var index: Int?;
  
  public var colorAccent: UIColor = ColorPreset.purpleA700.color;
  public var colorBgAccent: UIColor = ColorPreset.purple600.color;
  public var colorBg: UIColor = ColorPreset.purple100.color;
  public var colorTextAccent: UIColor = ColorPreset.purple900.color;
  
  public var colorTextDark: UIColor = {
    let rgba = ColorPreset.purple1000.color.rgba;
    
    return .init(
      red: rgba.r,
      green: rgba.g,
      blue: rgba.b,
      alpha: 0.8
    );
  }();
  
  public var content: [CardContentItem];
  
  // MARK: - Init
  // ------------
  
  init(
    title: String,
    subtitle: String? = nil,
    desc: [AttributedStringConfig],
    index: Int? = nil,
    colorAccent: UIColor? = nil,
    colorBgAccent: UIColor? = nil,
    colorBg: UIColor? = nil,
    colorTextAccent: UIColor? = nil,
    colorTextDark: UIColor? = nil,
    content: [CardContentItem]
  ) {
    self.title = title;
    self.subtitle = subtitle;
    self.desc = desc;
    self.index = index;
    
    if let colorAccent = colorAccent {
      self.colorAccent = colorAccent;
    };
    
    if let colorBgAccent = colorBgAccent {
      self.colorBgAccent = colorBgAccent;
    };
    
    if let colorBg = colorBg {
      self.colorBg = colorBg;
    };
    
    if let colorTextAccent = colorTextAccent {
      self.colorTextAccent = colorTextAccent;
    };
    
    if let colorTextDark = colorTextDark {
      self.colorTextDark = colorTextDark;
    };
    
    self.content = content;
  }
  
  // MARK: - Functions
  // -----------------
  
  func _createCardHeader() -> UIView {
    let isTitleOnly = self.subtitle == nil;
  
    let rootVStack = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fill;
      stack.alignment = .fill;
      stack.spacing = 8;
      
      stack.backgroundColor = self.colorBgAccent;
      
      stack.isLayoutMarginsRelativeArrangement = true;
      stack.layoutMargins = UIEdgeInsets(
        top: isTitleOnly ? 8 : 6,
        left: 10,
        bottom: 8,
        right: 10
      );
      
      return stack;
    }();
    
    let topRootView = UIView();
    rootVStack.addArrangedSubview(topRootView);
    
    let leftNumberIndicator = {
      let label = UILabel();
      label.text = "\(self.index ?? -1)";
      label.textColor = .white;
      
      label.font = UIFont.systemFont(ofSize: 16, weight: .heavy);
      label.textColor = .init(white: 1, alpha: 0.75);
      
      return label;
    }();
    
    topRootView.addSubview(leftNumberIndicator);
    leftNumberIndicator.translatesAutoresizingMaskIntoConstraints = false;
    leftNumberIndicator.setContentHuggingPriority(.defaultHigh, for: .horizontal);
    
    NSLayoutConstraint.activate([
      leftNumberIndicator.topAnchor.constraint(
        equalTo: topRootView.topAnchor
      ),
      leftNumberIndicator.bottomAnchor.constraint(
        equalTo: topRootView.bottomAnchor
      ),
      leftNumberIndicator.leadingAnchor.constraint(
        equalTo: topRootView.leadingAnchor
      ),
    ]);
    
    let rightStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fill;
      stack.alignment = .fill;
      
      return stack;
    }();
    
    rightStackView.addArrangedSubview({
      let label = UILabel();
      label.text = self.title;
      
      label.font = UIFont.systemFont(ofSize: 14, weight: .bold);
      label.textColor = .init(white: 1, alpha: 0.95);
      
      return label;
    }());
    
    if let subtitle = self.subtitle {
      let subtitleLabel = UILabel();
      subtitleLabel.text = subtitle;
      
      subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular);
      subtitleLabel.textColor = .init(white: 1, alpha: 0.75);
      
      rightStackView.addArrangedSubview(subtitleLabel);
    };
    
    topRootView.addSubview(rightStackView);
    rightStackView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      rightStackView.topAnchor.constraint(
        equalTo: topRootView.topAnchor
      ),
      rightStackView.bottomAnchor.constraint(
        equalTo: topRootView.bottomAnchor
      ),
      rightStackView.trailingAnchor.constraint(
        equalTo: topRootView.trailingAnchor
      ),
      leftNumberIndicator.trailingAnchor.constraint(
        equalTo: rightStackView.leadingAnchor,
        constant: -8
      ),
    ]);
    
    return rootVStack;
  };
    
  func _createCardBody() -> UIStackView {
    let bodyVStack = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fill;
      stack.alignment = .fill;
      stack.spacing = 12;
      
      stack.isLayoutMarginsRelativeArrangement = true;
      stack.layoutMargins = UIEdgeInsets(
        top: 8,
        left: 10,
        bottom: 8,
        right: 10
      );
                
      return stack;
    }();
    
    bodyVStack.addArrangedSubview({
      var configs: [AttributedStringConfig] = [
        .init(
          text: "Description: ",
          weight: .bold,
          color: self.colorTextAccent
        ),
      ];
      
      configs += self.desc;
      
      for index in 0..<configs.count {
        if configs[index].foregroundColor == nil {
          configs[index].foregroundColor = self.colorTextDark;
        };
      };
      
      let label = UILabel();
      label.font = nil;
      label.textColor = nil;
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping;
      label.attributedText = configs.makeAttributedString();
      
      return label;
    }());
    
    return bodyVStack;
  };
  
  public func createCardView() -> UIView {
    let rootVStack = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fill;
      stack.alignment = .fill;
      
      stack.layer.cornerRadius = 8;
      stack.layer.maskedCorners = .allCorners;
      
      stack.clipsToBounds = true;
                
      return stack;
    }();
    
    rootVStack.backgroundColor = self.colorBg;
    
    let headingVStack = self._createCardHeader();
    rootVStack.addArrangedSubview(headingVStack);
    
    let bodyVStack = self._createCardBody();
    rootVStack.addArrangedSubview(bodyVStack);

    return rootVStack;
  };
};

