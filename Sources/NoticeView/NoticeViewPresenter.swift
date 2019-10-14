//
//  NoticeViewPresenter.swift
//  
//
//  Created by Przemysław Bobak on 14/10/2019.
//

import UIKit

/// Presenter class to orchestrate the display of the notice view
open class NoticeViewPresenter: NSObject {
    /// isPresented returns whether the screen is visible to the user or not
    public var isPresented: Bool { topConstraint.constant != initialPosition }
    // titleLabel allows to modify the underlying title label
    public var titleLabel: UILabel { notice.titleLabel }
    // imageView allows to modify the underlying image view
    public var imageView: UIImageView? { notice.imageView }

    /// Presented notice view
    private let notice: NoticeView = NoticeView(frame: .zero)

    /// Container view that the notice is be added to
    private var containerView: UIView

    /// A top-most constraint that controls the presentation and dismissal of the notice view
    private var topConstraint: NSLayoutConstraint!

    /// An initial Y-position for the presented  notice state
    private var initialPosition: CGFloat = 0

    /// Initialize presenter class within
    /// - Parameter containerView: Container view that the notice should display within
    /// - Parameter backgroundColor: Background colour for the notice
    /// - Parameter textColor: Text colour for the notice
    public init(_ containerView: UIView, backgroundColor: UIColor = .lightGray, textColor: UIColor = .black) {
        self.containerView = containerView
        super.init()

        let estimatedSize = notice.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        calculateLayout(with: estimatedSize)
        setContainer(view: containerView)
        setTitle(color: textColor)
        setBackground(color: backgroundColor)
    }

    // MARK: - Presentation

    /// Presents the notice with given text
    /// - Parameter text: Text contents of the notice
    /// - Parameter interval: Optional time interval to dismiss the notice
    @objc public func present(_ text: String? = nil, dismissAfter interval: TimeInterval = 0) {
        // Presenting a new one, cancel previous dismissals
        cancelIfDismissing()

        if let val = text {
            setTitle(val)
        }

        if interval > 0 {
            perform(#selector(dismiss), with: nil, afterDelay: interval)
        }

        // There can only be one notice at given time.
        guard !isPresented else { return }

        calculateLayout(with: notice.frame.size)
        animateIn()
    }

    /// Dismisses the presented notice
    @objc public func dismiss() {
        guard isPresented else { return }

        animateOut()
    }

    /// Toggles the presentation of the notice view. Any dismiss intervals will get cancelled.
    @objc public func toggle() {
        cancelIfDismissing()

        topConstraint.constant == initialPosition ? dismiss() : present()
    }

    // MARK: - Content

    /// Modifies the text contents of the notice. If the notice is not visible, it will get presented automatically
    /// - Parameter text: A new text value
    @objc public func setTitle(_ text: String) {
        notice.titleLabel.text = text
        notice.setNeedsLayout()
        notice.layoutIfNeeded()
    }

    /// Modifies the text colour of the notice
    /// - Parameter color: A new text colour
    @objc public func setTitle(color: UIColor) {
        notice.titleLabel.textColor = color
    }

    /// Modifies the background colour of the notice
    /// - Parameter color: A new background colour
    @objc public func setBackground(color: UIColor) {
        notice.backgroundColor = color
    }

    /// Modifies the container view that presents the notice within
    /// - Parameter view: A new container view
    @objc public func setContainer(view: UIView) {
        notice.removeFromSuperview()
        containerView = view
        containerView.addSubview(notice)
        notice.translatesAutoresizingMaskIntoConstraints = false
        notice.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        notice.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        notice.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        notice.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        topConstraint = notice.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -250)
        topConstraint.isActive = true
    }

    // MARK: - Private

    /// Animates the presentation of the notice
    private func animateIn() {
        topConstraint.constant = initialPosition
        notice.setNeedsLayout()
        notice.transform = CGAffineTransform(translationX: 0, y: -notice.frame.height)
        self.notice.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.notice.alpha = 1
            self.notice.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }

    /// Animates the dismissal of the notice
    private func animateOut() {
        notice.transform = .identity
        notice.alpha = 1
        let height = notice.frame.height

        UIView.animate(withDuration: 0.3, animations: {
            self.notice.alpha = 0
            self.notice.transform = CGAffineTransform(translationX: 0, y: -height)
        }) { (_) in
            self.topConstraint.constant = -height
            self.notice.setNeedsLayout()
        }
    }

    /// Ensures the container view is properly positioned to be able to display a view.
    /// If the container view is a table view, it adjusts the contentInset and contentOffset to accomodate for the notice size
    /// - Parameter size: An estimated or calculated size of the notice view
    private func calculateLayout(with size: CGSize) {
        if let tableView = containerView as? UITableView {
            initialPosition = -size.height
            tableView.contentInset = UIEdgeInsets(top: size.height, left: 0, bottom: 0, right: 0)
            tableView.setContentOffset(CGPoint(x: 0, y: -size.height), animated: false)

            if !tableView.visibleCells.isEmpty {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }

            tableView.updateConstraints()
        } else {
            initialPosition = 0
        }
    }

    /// Cancel any pending dismissals
    private func cancelIfDismissing() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
}

