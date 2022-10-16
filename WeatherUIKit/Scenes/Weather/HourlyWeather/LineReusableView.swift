///Отрывок из книги
///Develop in Swift Data Collections
///Apple Education
///https://books.apple.com/ru/book/develop-in-swift-data-collections/id1581183203

import UIKit

final class LineReusableView: UICollectionReusableView {
    
//    static let reuseIdentifier = "LineView"
//    var lineWidth: CGFloat = 0.5

//    override var intrinsicContentSize: CGSize {
//        .init(width: 0, height: lineWidth)
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brandPurpleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(_ color: UIColor) {
        backgroundColor = color
    }
    
}
