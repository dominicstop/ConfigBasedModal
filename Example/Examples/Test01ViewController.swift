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


class Test01ViewController: UIViewController {

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
    
    var cardConfig: [CardConfig] = [];
    
    cardConfig.append(
      .init(
        title: "Test Present",
        desc: [
          .init(text: "Simple test for presenting modals")
        ],
        index: cardConfig.count + 1,
        content: [
          .filledButton(
            title: [.init(text: "Present Modal")],
            handler: { _ in
              let manager = ModalConfigManager();
              let modalVC = Test01ViewController();
              
              manager.presentModal(
                viewControllerToPresent: modalVC
              );
            }
          ),
          .filledButton(
            title: [.init(text: "Log Modal Details")],
            handler: { _ in
              print(
                "Log Modal Details:",
                "\n - isPresentedAsModal:", self.isPresentedAsModal,
                "\n - presentingViewController:", self.presentingViewController?.debugDescription ?? "N/A",
                "\n - presentedViewController:", self.presentedViewController?.debugDescription ?? "N/A",
                "\n - modalLevel:", self.modalLevel?.description ?? "N/A",
                "\n - Presented modal count:", self.recursivelyGetAllPresentedViewControllers.count,
                "\n"
              );
              
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
    );
    
    cardConfig.append(
      .init(
        title: "Some Title Lorum Ipsum",
        subtitle: "One short subtitle",
        desc: [
          .init(text: "One medium desc here lorum ipsum sit amit Ultricies Vestibulum Aenean Condimentum Elit")
        ],
        index: cardConfig.count + 1,
        content: [
          .filledButton(
            title: [.init(text: "Button")],
            subtitle: [.init(text: "Subtitle lorum ipsum")],
            handler: { _ in
              print("pressed");
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
      let cardView = $0.createCardView();
      stackView.addArrangedSubview(cardView);
      stackView.setCustomSpacing(15, after: cardView);
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
};
