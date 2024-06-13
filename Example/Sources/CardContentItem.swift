//
//  CardContentItem.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/9/24.
//

import UIKit
import ConfigBasedModal

public enum CardContentItem {

  case filledButton(
    title: [AttributedStringConfig],
    subtitle: [AttributedStringConfig]? = nil,
    controlEvent: UIControl.Event = .primaryActionTriggered,
    handler: (() -> Void)?
  );
  
  case label([AttributedStringConfig]);
  case multiLineLabel([AttributedStringConfig]);
  
  case spacer(space: CGFloat);
  
  // MARK: Functions
  // ---------------
  
  func makeContent(themeColorConfig: ColorThemeConfig) -> UIView {
    switch self {
      case let .filledButton(title, subtitle, controlEvent, handler):
        let button = UIButton(type: .system);
        
        var attributedStringConfigs: [AttributedStringConfig] = [];
        attributedStringConfigs += title.map {
          var config = $0;
          if config.fontConfig.weight == nil {
            config.fontConfig.weight = .bold;
          };
          
          return config;
        };
        
        if var subtitle = subtitle,
           subtitle.count > 0 {
          
          subtitle.insert(.newLine, at: 0);
          attributedStringConfigs += subtitle.map {
            var config = $0;
            if config.fontConfig.weight == nil {
              config.fontConfig.size = 14;
            };
            
            return config;
          };
          
          button.titleLabel?.lineBreakMode = .byWordWrapping;
          button.contentHorizontalAlignment = .left;
          
          button.contentEdgeInsets =
            .init(top: 6, left: 12, bottom: 6, right: 12);
          
        } else {
          button.contentEdgeInsets =
            .init(top: 8, left: 8, bottom: 8, right: 8);
        };
        
        for index in 0..<attributedStringConfigs.count {
          if attributedStringConfigs[index].foregroundColor == nil {
            attributedStringConfigs[index].foregroundColor = themeColorConfig.colorTextLight;
          };
        };
        
        let attributedString =
          attributedStringConfigs.makeAttributedString();
        
        button.setAttributedTitle(attributedString, for: .normal);
        
        button.tintColor = .white
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = true;
        
        let imageConfig = ImageConfigSolid(
          fillColor: themeColorConfig.colorBgAccent
        );
        
        button.setBackgroundImage(
          imageConfig.makeImage(),
          for: .normal
        );
        
        if let handler = handler {
          button.addAction(for: controlEvent, action: handler);
        };
        
        return button;
        
      case let .label(configs):
        let label = UILabel();
        
        label.font = nil;
        label.textColor = nil;
        label.attributedText = configs.makeAttributedString();
        
        return label;
        
      case let .multiLineLabel(configs):
        let label = UILabel();
        
        label.font = nil;
        label.textColor = nil;
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping;
        
        label.attributedText = configs.makeAttributedString();
        return label;
        
      case let .spacer(space):
        return UIView(frame: .init(
          origin: .zero,
          size: .init(width: 0, height: space)
        ));
    };
  };
};
