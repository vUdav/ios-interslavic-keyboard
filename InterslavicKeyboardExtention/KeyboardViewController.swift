import UIKit

class KeyboardViewController: UIInputViewController {

    let cyrillicLetters = [
        ["j", "ц", "у", "к", "е", "н", "њ", "г", "ш", "з", "х"],
        ["ф", "ы", "в", "а", "п", "р", "о", "л", "љ", "д", "ж"],
        ["ч", "с", "м", "и", "т", "б", "є"]
    ]
    
    let latinLetters = [
        ["é", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "ś", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["ź", "z", "ć", "c", "v", "b", "n", "m"]
    ]
    
    var currentLanguage: String = "КИР"
    var isUppercase: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }

    func setupKeyboard() {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }

        let keyboardView = UIStackView()
        keyboardView.axis = .vertical
        keyboardView.alignment = .fill
        keyboardView.distribution = .fillEqually
        keyboardView.spacing = 10
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
        
        var letters = currentLanguage == "КИР" ? cyrillicLetters : latinLetters
        
        if isUppercase {
            letters = letters.map { $0.map { $0.uppercased() } }
        }

        for row in letters {
            let rowView = createRowOfButtons(row)
            keyboardView.addArrangedSubview(rowView)
        }

        let bottomRowView = createBottomRowOfButtons()
        keyboardView.addArrangedSubview(bottomRowView)

        let padding: CGFloat = 10.0 // Установите нужное значение отступов

        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func createRowOfButtons(_ letters: [String]) -> UIStackView {
        let rowView = UIStackView()
        rowView.axis = .horizontal
        rowView.alignment = .fill
        rowView.distribution = .fillEqually
        rowView.spacing = 5

        for letter in letters {
            let button = createLetterButton(letter)
            rowView.addArrangedSubview(button)
        }

        return rowView
    }
    
    func createBottomRowOfButtons() -> UIStackView {
        let rowView = UIStackView()
        rowView.axis = .horizontal
        rowView.alignment = .fill
        rowView.distribution = .fillEqually
        rowView.spacing = 5

        let shiftButton = createButton("")
        let shiftImageSyss = isUppercase ? "shift.fill" : "shift"
        let shiftImage = UIImage(systemName: shiftImageSyss)?.withRenderingMode(.alwaysTemplate)
        shiftButton.setImage(shiftImage, for: .normal)
        shiftButton.tintColor = UIColor.black
        shiftButton.addTarget(self, action: #selector(shiftTapped), for: .touchUpInside)
        rowView.addArrangedSubview(shiftButton)

        let switchLanguageButton = createButton(currentLanguage)
        switchLanguageButton.addTarget(self, action: #selector(switchLanguageTapped), for: .touchUpInside)
        rowView.addArrangedSubview(switchLanguageButton)
        
        let spaceButton = createLetterButton(" ")
        rowView.addArrangedSubview(spaceButton)

        let backspaceButton = createButton("")
        let backspaceImage = UIImage(systemName: "delete.left")?.withRenderingMode(.alwaysTemplate)
        backspaceButton.setImage(backspaceImage, for: .normal)
        backspaceButton.tintColor = UIColor.black
        backspaceButton.addTarget(self, action: #selector(backspaceTapped), for: .touchUpInside)
        rowView.addArrangedSubview(backspaceButton)

        return rowView
    }

    func createLetterButton(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false

        // Set button style
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.0

        button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
        return button
    }
    
    func createButton(_ title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false

        // Set button style
        button.backgroundColor = UIColor.systemGray
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 1.0

        return button
    }

    @objc func keyTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        (textDocumentProxy as UIKeyInput).insertText(title)

        if isUppercase {
            isUppercase = false
            setupKeyboard()
        }
    }
    
    @objc func shiftTapped() {
        isUppercase.toggle()
        setupKeyboard()
    }

    @objc func switchLanguageTapped() {
        currentLanguage = currentLanguage == "КИР" ? "LAT" : "КИР"
        setupKeyboard()
    }

    @objc func backspaceTapped() {
        (textDocumentProxy as UIKeyInput).deleteBackward()
    }
}
