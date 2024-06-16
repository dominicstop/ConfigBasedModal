//
//  Test01ViewController.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/8/24.
//

import UIKit
import DGSwiftUtilities
import ConfigBasedModal


class ModalViewController: UIViewController {
  
  override func viewDidLoad() {
    self.view.backgroundColor = .white;
  };
};


class Test01ViewController: UIViewController, ModalFocusEventsNotifiable {

  var cardThemeConfig: ColorThemeConfig = .presetPurple;
  var modalDebugDisplayVStack: UIStackView?;
  
  var _didSetupGestureRecognizer = false;
  
  override func viewDidLoad() {
    self.view.backgroundColor = .white;
    
    let stackView: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fill;
      stack.alignment = .fill;
      stack.spacing = 15;
                
      return stack;
    }();
    
    let cardColorThemeConfig = ColorThemeConfig.presetPurple;
    var cardConfig: [CardConfig] = [];
    
    cardConfig.append({
      let modalDebugDisplayVStack = self.setModalDebugDisplay();
      
      return .init(
        title: "Test Present",
        desc: [
          .init(text: "Simple test for presenting modals")
        ],
        index: cardConfig.count + 1,
        content: [
          .view(modalDebugDisplayVStack),
          .filledButton(
            title: [.init(text: "Present Modal")],
            handler: { _,_ in
              let manager = ModalConfigManager();
              let modalVC = Test01ViewController();
              
              manager.presentModal(
                viewControllerToPresent: modalVC
              );
            }
          ),
          .filledButton(
            title: [.init(text: "Log Modal Details")],
            handler: { _,_ in
              self.setModalDebugDisplay();
              
              print(
                "recursivelyGetAllPresentedViewControllers:",
                self.recursivelyGetAllPresentedViewControllers.enumerated().reduce(into: ""){
                  $0 += "\n - \($1.offset): \($1.element)";
                  $0 += "\n   + isPresentedAsModal: \($1.element.isPresentedAsModal)";
                  $0 += "\n   + isTopMostModal: \($1.element.isTopMostModal)";
                  $0 += "\n   + modalLevel: \($1.element.modalLevel?.description ?? "N/A")";
                  $0 += "\n";
                },
                "\n"
              );
            }
          ),
        ]
      )
    }());
    
    cardConfig.append(
      .init(
        title: "Modal Presentation Tests",
        subtitle: "modal api testing + experiments",
        desc: [],
        index: cardConfig.count + 1,
        content: [
          .filledButton(
            title: [.init(text: "Dismiss Current")],
            subtitle: [.init(text: "Invoke `dismiss`")],
            handler: { _, _ in
              // self.presentingViewController?.dismiss(animated: true);
              self.dismiss(animated: true);
            }
          ),
          
          .filledButton(
            title: [.init(text: "Basic Present Modal")],
            subtitle: [.init(text: "present using `present`")],
            handler: { _, _ in
            
              let modalVC = Self.init();
              self.present(modalVC, animated: true);
            }
          ),
          
          .filledButton(
            title: [.init(text: "Present Modal in Fullscreen")],
            subtitle: [.init(text: "modalPresentationStyle = fullScreen")],
            handler: { config, button in
              let modalVC = Self.init();
              modalVC.modalPresentationStyle = .fullScreen;
              self.present(modalVC, animated: true);
            }
          ),
          
          .filledButton(
            title: [.init(text: "Popover + Sheet Test")],
            subtitle: [.init(text: "present modal as popover w/ sheet config")],
            handler: { config, button in
              guard #available(iOS 15.0, *) else { return };
            
              let modalVC = Self.init();
              modalVC.modalPresentationStyle = .popover;
              modalVC.preferredContentSize = CGSize(width: 200, height: 200);
              
              if let popoverController = modalVC.popoverPresentationController {
                popoverController.sourceView = button;
                
                let sheetController =
                  popoverController.adaptiveSheetPresentationController;
                
                sheetController.detents = [.medium()];
                sheetController.prefersGrabberVisible = true;
                sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = true;
              };

              self.present(modalVC, animated: true)

            }
          ),
          
          .filledButton(
            title: [.init(text: "Sheet + SourceView Test")],
            subtitle: [.init(text: "present sheet + sourceView")],
            handler: { config, button in
              guard #available(iOS 15.0, *) else { return };
            
              let modalVC = Self.init();
              modalVC.modalPresentationStyle = .pageSheet;
              
              guard let sheetController = modalVC.sheetPresentationController else {
                return;
              };
              
              sheetController.detents = [.medium()];
              sheetController.prefersGrabberVisible = true;
              sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = true;
              sheetController.sourceView = button;
              
              self.present(modalVC, animated: true)

            }
          ),
        ]
      )
    );
    
    cardConfig.append(
      .init(
        title: "Some Title Lorum Ipsum",
        subtitle: "Some subtitle lorum ipsum",
        desc: [
          .init(text: "One short desc here lorum ipsum"),
          .newLines(2),
          .init(text: "One medium desc here lorum ipsum sit amit Ultricies Vestibulum Aenean Condimentum Elit"),
          .init(text:
              "One long desc here, Maecenas faucibus mollis interdum Quam Adipiscing Tellus Nullam Mattis"
            + " Aenean Elit Consectetur Dolor; Cursus Cum sociis natoque penatibus et magnis, dis parturient"
          ),
        ],
        index: cardConfig.count + 1,
        content: []
      )
    );
    
    cardConfig.append(
      .init(
        title: "Some Title Lorum Ipsum",
        subtitle: "Some subtitle here lorum ",
        desc: [
          .init(text: "Some desc here lorum ipsum sit amit dolor aspicing Ultricies Vestibulum Aenean Condimentum Elit")
        ],
        index: cardConfig.count + 1,
        content: [
          .labelValueDisplay(items: [
            .singleRowPlain(
              label: "title",
              value: "value"
            ),
            .singleRowPlain(
              label: "some title 2",
              value: "some value 2"
            ),
            .singleRowPlain(
              label: "some other value 3",
              value: "some other value 3"
            ),
          ]),
        ]
      )
    );
    
    cardConfig.forEach {
      var cardConfig = $0;
      cardConfig.colorThemeConfig = cardColorThemeConfig;
      
      let cardView = cardConfig.createCardView();
      stackView.addArrangedSubview(cardView.rootVStack);
      stackView.setCustomSpacing(15, after: cardView.rootVStack);
    };
    
    let scrollView: UIScrollView = {
      let scrollView = UIScrollView();
      
      scrollView.showsHorizontalScrollIndicator = false;
      scrollView.showsVerticalScrollIndicator = true;
      scrollView.alwaysBounceVertical = true;
      return scrollView
    }();
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.addSubview(stackView);
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(
        equalTo: scrollView.topAnchor,
        constant: 40
      ),
      
      stackView.bottomAnchor.constraint(
        equalTo: scrollView.bottomAnchor,
        constant: -100
      ),
      
      stackView.centerXAnchor.constraint(
        equalTo: scrollView.centerXAnchor
      ),
      
      stackView.widthAnchor.constraint(
        equalTo: scrollView.widthAnchor,
        constant: -24
      ),
    ]);
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(scrollView);
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor
      ),
      scrollView.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
      ),
      scrollView.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
      ),
      scrollView.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
      ),
    ]);
  };
  
  override func viewDidAppear(_ animated: Bool) {
    self.setupGestureRecognizer();
  }
  
  func setupGestureRecognizer(){
    guard let gesture = self.modalGestureRecognizer,
          !self._didSetupGestureRecognizer
    else { return };
    
    gesture.addAction { [unowned self] _ in
      self.setModalDebugDisplay();
    };
  };
  
  @discardableResult
  func setModalDebugDisplay() -> UIStackView {
    var displayItems: [CardLabelValueDisplayItemConfig] = [];
    
    displayItems += [
      .singleRowPlain(
        label: "doesSupportModalGestures",
        value: self.doesSupportModalGestures
      ),
      .singleRowPlain(
        label: "doesReportModalEvents",
        value: self.doesReportModalEvents
      ),
      .singleRowPlain(
        label: "Modal Gesture State",
        value: self.modalGestureRecognizer?.state.description ?? "N/A"
      ),
      .singleRowPlain(
        label: "Modal ScrollView Gesture State",
        value: self.modalRootScrollViewGestureRecognizer?.state.description ?? "N/A"
      ),
    ];
    
    displayItems += {
      guard let modalPresentationState = self.modalPresentationState else {
        return [
          .singleRowPlain(
            label: "Presentation State",
            value: "N/A"
          ),
        ];
      };
      
      var items: [CardLabelValueDisplayItemConfig] = [
        .singleRowPlain(
          label: "Presentation State",
          value: modalPresentationState.memberName
        ),
        .singleRowPlain(
          label: "presentationTrigger",
          value: modalPresentationState.presentationTrigger.rawValue
        ),
      ];
      
      switch modalPresentationState {
        case let .presenting(_, wasDismissCancelled):
          items.append(
            .singleRowPlain(
              label: "wasDismissCancelled",
              value: wasDismissCancelled
            )
          );
          
        case let .presented(_, wasDismissCancelled):
          items.append(
            .singleRowPlain(
              label: "wasDismissCancelled",
              value: wasDismissCancelled
            )
          );
          
        default:
          break;
      };
      
      return items;
    }();
    
    displayItems += {
      guard let modalFocusState = self.modalFocusState else {
        return [
          .singleRowPlain(
            label: "Focus State",
            value: "N/A"
          ),
        ];
      };
      
      return [
        .singleRowPlain(
          label: "Focus State",
          value: modalFocusState.rawValue
        ),
      ];
    }();
    
    displayItems += [
      .singleRowPlain(
        label: "isPresentedAsModal",
        value: self.isPresentedAsModal
      ),
      .singleRowPlain(
        label: "presentingVC",
        value: {
          guard let presentingVC = self.presentingViewController else {
            return "N/A";
          };
        
          let pointer = Unmanaged.passUnretained(presentingVC);
          return "\(pointer.toOpaque())";
        }()
      ),
      .singleRowPlain(
        label: "presentedVC",
        value: {
          guard let presentingVC = self.presentedViewController else {
            return "N/A";
          };
        
          let pointer = Unmanaged.passUnretained(presentingVC);
          return "\(pointer.toOpaque())";
        }()
      ),
      
      .singleRowPlain(
        label: "currentVC",
        value: {
          let pointer = Unmanaged.passUnretained(self);
          return "\(pointer.toOpaque())";
        }()
      ),
      .singleRowPlain(
        label: "modalLevel",
        value: self.modalLevel?.description ?? "N/A"
      ),
      .singleRowPlain(
        label: "Presented Modal Count",
        value: self.recursivelyGetAllPresentedViewControllers.count
      ),
    ];
    
    let displayConfig = CardLabelValueDisplayConfig(
      items: displayItems,
      deriveColorThemeConfigFrom: self.cardThemeConfig
    );
    
    let rootVStack = self.modalDebugDisplayVStack ?? .init();
    self.modalDebugDisplayVStack = rootVStack;
    
    rootVStack.removeAllArrangedSubviews();
    let displayView = displayConfig.createView();
    rootVStack.addArrangedSubview(displayView);
    
    return rootVStack;
  };

  func notifyForModalFocusStateChange(
    prevState: ModalFocusState,
    nextState: ModalFocusState
  ) {
    self.setModalDebugDisplay();
  };
};
