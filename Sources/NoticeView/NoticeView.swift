//
//  NoticeView.swift
//
//
//  Created by Przemysław Bobak on 14/10/2019.
//

import UIKit

open class NoticeView: UIView {
    open var imageView: UIImageView = makeView(type: UIImageView.self)
    open var titleLabel: UILabel = makeLabel()

    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }

    private static func makeView<T: UIView>(type _: T.Type) -> T {
        let view = T(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabelsAndConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLabelsAndConstraints()
    }

    private func setUpLabelsAndConstraints() {
        let boldFont = UIFont.preferredFont(forTextStyle: .body).fontDescriptor.withSymbolicTraits(.traitBold)!
        titleLabel.textAlignment = .center
        titleLabel.font =  UIFont(descriptor: boldFont, size: 0)

        addSubview(titleLabel)
        addSubview(imageView)

        // TODO: Layout the image view…

        titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        titleLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor, multiplier: 1).isActive = true
        bottomAnchor.constraint(equalToSystemSpacingBelow: titleLabel.lastBaselineAnchor, multiplier: 1).isActive = true
    }
}
