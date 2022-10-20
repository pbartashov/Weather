///Отрывок из книги
///Develop in Swift Data Collections
///Apple Education
///https://books.apple.com/ru/book/develop-in-swift-data-collections/id1581183203

import UIKit

final class LineReusableView: UICollectionReusableView {

    // MARK: - LifeCicle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brandPurpleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Metods

    func setColor(_ color: UIColor) {
        backgroundColor = color
    }
}
