//
//  OrderView.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/24/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class OrderView : UIView {
    
    var shipAddress = ""
    var name = ""
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 30
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

        return view
    }()

    lazy var addCardButton = ActionButton(backgroundColor: Color.primaryAction, title: "Pay with card", image: nil)
    lazy var applePayButton = ActionButton(backgroundColor: Color.applePayBackground, title: nil, image: #imageLiteral(resourceName: "ApplePay"))
    private lazy var headerView = HeaderView(title: "Place your order")

    var closeButton: UIButton {
        return headerView.closeButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func commonInit() {
        
        print(shipAddress)
        
        backgroundColor = Color.popupBackground

        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(TableRowView(heading: "Ship to", title: name , subtitle: shipAddress))
        stackView.addArrangedSubview(HairlineView())
        stackView.addArrangedSubview(TableRowView(heading: "Total", title: "$1.00", subtitle: nil))
        stackView.addArrangedSubview(HairlineView())
        stackView.addArrangedSubview(makeRefundLabel())

        let payStackView = UIStackView()
        payStackView.spacing = 12
        payStackView.distribution = .fillEqually
        payStackView.addArrangedSubview(addCardButton)
        payStackView.addArrangedSubview(applePayButton)
        stackView.addArrangedSubview(payStackView)

        addSubview(stackView)

        stackView.pinToTop(ofView: self)
    }
}

extension OrderView {
    private func makeRefundLabel() -> UILabel {
        let label = UILabel()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let attributes = [NSAttributedString.Key.paragraphStyle : paragraphStyle]

        label.attributedText = NSMutableAttributedString(string: "You can refund this transaction through your Square dashboard, goto squareup.com/dashboard.", attributes: attributes)
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
}
