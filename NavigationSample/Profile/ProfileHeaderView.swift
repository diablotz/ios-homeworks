//
//  ProfileHeaderView.swift
//  Navigation
//

import UIKit

final class ProfileHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Visual objects
    
    var fullNameLabel = UILabel()
    var avatarImageView = UIImageView()
    var statusLabel = UILabel()
    var statusTextField = UITextField()
    var setStatusButton = UIButton()
   // var returnAvatarButton = UIButton()
    //var avatarBackground = UIView()
    private var overlayView: UIView?
    private var animatedImageView: UIImageView?
    private var originalFrame: CGRect = .zero
    
    private var statusText = "Ready to help"
    private var avatarOriginPoint = CGPoint()
    
    // MARK: - Setup section
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupNameLabel()
        setupStatusLabel()
        setupStatusTextField()
        setupStatusButton()
        setupAvatarImage()
        
        
        statusTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("lol")
    }
    
    private func setupNameLabel() {
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        //fullNameLabel.text = "Teo West"
        fullNameLabel.font = .boldSystemFont(ofSize: 18)
        fullNameLabel.textColor = .black
        addSubview(fullNameLabel)
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            fullNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 156),
            fullNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            fullNameLabel.heightAnchor.constraint(equalToConstant: 28),
        ])
    }
    
    private func setupStatusLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        //statusLabel.text = statusText
        statusLabel.font = .systemFont(ofSize: 17)
        statusLabel.textColor = .black
        addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            statusLabel.heightAnchor.constraint(equalTo: fullNameLabel.heightAnchor),
        ])
    }
    
    private func setupStatusTextField() {
        statusTextField.translatesAutoresizingMaskIntoConstraints = false
        statusTextField.textColor = .darkGray
        statusTextField.backgroundColor = .white
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        statusTextField.leftView = paddingView
        statusTextField.leftViewMode = .always
        statusTextField.layer.cornerRadius = 8
        statusTextField.layer.borderWidth = 1
        statusTextField.layer.borderColor = UIColor.gray.cgColor
        statusTextField.attributedPlaceholder = NSAttributedString.init(string: "Ready...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        statusTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        addSubview(statusTextField)
        NSLayoutConstraint.activate([
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            statusTextField.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private func setupStatusButton() {
        setStatusButton.translatesAutoresizingMaskIntoConstraints = false
        setStatusButton.backgroundColor = .systemBlue
        setStatusButton.layer.cornerRadius = LayoutConstants.cornerRadius
        setStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
        setStatusButton.layer.shadowRadius = 4
        setStatusButton.layer.shadowOpacity = 0.7
        setStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        setStatusButton.setTitle("Show status", for: .normal)
        setStatusButton.setTitleColor(.white, for: .normal)
        setStatusButton.addTarget(self, action: #selector(statusButtonPressed), for: .touchUpInside)
        addSubview(setStatusButton)
        NSLayoutConstraint.activate([
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    // заплатка
    func configure(with user: User) {
        self.fullNameLabel.text = user.fullName
        self.statusLabel.text = user.status
        self.avatarImageView.image = user.avatar
        print("Configgggg!!!!")
    }
    private func setupAvatarImage() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        //avatarImageView.image = user.avatar //UIImage(named: "teo")
        avatarImageView.layer.cornerRadius = 64
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true
        
        // add a tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnAvatar))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        
        // cancel an animation mode
        /*returnAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        returnAvatarButton.alpha = 0
        returnAvatarButton.backgroundColor = .clear
        returnAvatarButton.contentMode = .scaleToFill
        returnAvatarButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))?.withTintColor(.black, renderingMode: .automatic), for: .normal)
        returnAvatarButton.tintColor = .black
        returnAvatarButton.addTarget(self, action: #selector(returnAvatarToOrigin), for: .touchUpInside)
        
        // translucent background for the modal animation mode
        //guard let windowScene = self.window?.windowScene else { return }
        //let screenBounds = windowScene.screen.bounds
        avatarBackground = UIView()//UIView(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height))
        avatarBackground.backgroundColor = .darkGray
        avatarBackground.isHidden = false
        avatarBackground.alpha = 0
        */
        //addSubviews(avatarBackground, avatarImageView, returnAvatarButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 128),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            //returnAvatarButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            //returnAvatarButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - Event handlers
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
    
    @objc private func statusButtonPressed() {
        statusLabel.text = statusText
    }
    @objc private func didTapOnAvatar() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {return}
        // переводим координаты avatar в систему окна
        originalFrame = avatarImageView.convert(avatarImageView.bounds, to: window)
        
        // затемнение фона
        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0
        window.addSubview(overlay)
        
        // создаём копию аватара
        let imageView = UIImageView(frame: originalFrame)
        imageView.image = avatarImageView.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        window.addSubview(imageView)
        
        // скрываем оригинал
        avatarImageView.isHidden = true
        
        overlayView = overlay
        animatedImageView = imageView
        
        // анимация
        UIView.animate(withDuration: 0.4) {
            overlay.alpha = 0.7
            
            let size = window.bounds.width
            imageView.frame = CGRect(
                x: 0,
                y: (window.bounds.height - size) / 2,
                width: size,
                height: size
            )
            imageView.layer.cornerRadius = 0
        }
        
        // тап для закрытия
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAvatar))
        overlay.addGestureRecognizer(tap)
    }
    /*
    @objc private func didTapOnAvatar() {
        // create an animation
        avatarImageView.isUserInteractionEnabled = false
        
        ProfileViewController.postTableView.isScrollEnabled = false
        ProfileViewController.postTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = false
        
        avatarOriginPoint = avatarImageView.center
        guard let windowScene = self.window?.windowScene else { return }
        let screenBounds = windowScene.screen.bounds
        let scale = screenBounds.width / avatarImageView.bounds.width
        
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.center = CGPoint(x: screenBounds.midX,
                                                  y: screenBounds.midY - self.avatarOriginPoint.y)
            self.avatarImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.avatarImageView.layer.cornerRadius = 0
            self.avatarBackground.isHidden = false
            self.avatarBackground.alpha = 0.7
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.returnAvatarButton.alpha = 1
            }
        }
    }
     */
    /*
    @objc private func returnAvatarToOrigin() {
        UIImageView.animate(withDuration: 0.5) {
            UIImageView.animate(withDuration: 0.5) {
                self.returnAvatarButton.alpha = 0
                self.avatarImageView.center = self.avatarOriginPoint
                self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                self.avatarBackground.alpha = 0
            }
        } completion: { _ in
            ProfileViewController.postTableView.isScrollEnabled = true
            ProfileViewController.postTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = true
            self.avatarImageView.isUserInteractionEnabled = true
        }
    }
     */
    @objc private func closeAvatar() {
        guard let window = UIApplication.shared.connectedScenes.first,
              let imageView = animatedImageView,
              let overlay = overlayView else { return }
        
        UIView.animate(withDuration: 0.4, animations: {
            imageView.frame = self.originalFrame
            imageView.layer.cornerRadius = imageView.frame.width / 2
            overlay.alpha = 0
        }) { _ in
            imageView.removeFromSuperview()
            overlay.removeFromSuperview()
            
            self.avatarImageView.isHidden = false
            
            self.animatedImageView = nil
            self.overlayView = nil
        }
    }
}

// MARK: - Extension

extension ProfileHeaderView: UITextFieldDelegate {
    
    // tap 'done' on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
