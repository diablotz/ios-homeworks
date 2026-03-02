//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Timur Zakirov on 02/03/26.
//
import UIKit

class ProfileHeaderView: UIView {
    
 //  кнопка показа статуса
 let showStatusBatton: UIButton = {
     let button = UIButton(type: .system)
     button.setTitle("CHange status", for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.backgroundColor = .systemBlue
     button.layer.cornerRadius = 4
     button.layer.shadowColor = UIColor.black.cgColor
     button.layer.shadowRadius = 4
     button.layer.shadowOpacity = 0.7
     button.layer.shadowOffset = CGSize(width: 4, height: 4)
     return button
 } ()
 
 //  кнопка установления статуса
 let setStatusBatton: UIButton = {
     let button = UIButton(type: .system)
     button.setTitle("Set status", for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.backgroundColor = .systemBlue
     button.isHidden = true
     button.layer.cornerRadius = 4
     button.layer.shadowColor = UIColor.black.cgColor
     button.layer.shadowRadius = 4
     button.layer.shadowOpacity = 0.7
     button.layer.shadowOffset = CGSize(width: 4, height: 4)
     return button
 } ()
 
 // поле ввода статуса
 let setStatusField: UITextField = {
     let textField = UITextField()
     textField.text = "Listening to music"
     textField.backgroundColor = .white
     textField.isHidden = true
     textField.font = UIFont.systemFont(ofSize: 15)
     textField.textColor = .black
     textField.layer.borderColor = UIColor.black.cgColor
     textField.layer.borderWidth = 1
     textField.layer.cornerRadius = 12
     textField.leftView = UIView(frame: CGRect(x:0, y:0, width:12, height:40))
     textField.leftViewMode = .always
     return textField
 } ()
 
     // Статус
     let statusLabel: UILabel = {
         let label = UILabel()
         label.text = "Waiting for something..."
         label.font = UIFont.systemFont(ofSize: 14)
         label.textColor = .gray
         return label
     } ()
    // круглая аватарка
    let avatarkaImageView: UIImageView = {
        let ava = UIImageView()
        ava.image = UIImage(resource: .dog) // изначально использовал named: "dog", потом решил заменить
        ava.contentMode = .scaleAspectFill
        ava.clipsToBounds = true
        ava.layer.borderColor = UIColor.white.cgColor
        ava.layer.borderWidth = 3
        ava.layer.cornerRadius = 50
        return ava
    }()
    
    // Надпись Hipster cat
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Running dog"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    } ()
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setupViews()
        setupTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(avatarkaImageView)
        addSubview(nameLabel)
        addSubview(statusLabel)
        addSubview(showStatusBatton)
        addSubview(setStatusField)
        addSubview(setStatusBatton)
         
    }
    
    func setupTarget() {
        showStatusBatton.addTarget(
            self,
            action: #selector(showBattonPressed),
            for: .touchUpInside
        )
        
        setStatusBatton.addTarget(
            self,
            action: #selector(setBattonPressed),
            for: .touchUpInside
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // фрейм аватарки
        avatarkaImageView.frame = CGRect(
            x: 16,
            y: 16,
            width: 100,
            height: 100
        )
        
        // фрейм имени
        nameLabel.frame = CGRect(
            x: avatarkaImageView.frame.maxX + 16,
            y: avatarkaImageView.frame.minY + 27 - 16,
            width: bounds.width - 16 - avatarkaImageView.frame.maxX - 16,
            height: 22
        )
        
        // фрейм статуса
        statusLabel.frame = CGRect(
            x: avatarkaImageView.frame.maxX + 16,
            y: avatarkaImageView.frame.maxY - 34,
            width: bounds.width - 16 - avatarkaImageView.frame.maxX - 16,
            height: 22
        )
        
        // фрейм кнопки Show
        showStatusBatton.frame = CGRect(
            x: 16,
            y: avatarkaImageView.frame.maxY + 16,
            width: bounds.width - 32,
            height: 50
        )
        
        // фрейм текстового поля
        setStatusField.frame = CGRect(
            x: avatarkaImageView.frame.maxX + 16,
            y: statusLabel.frame.maxY + 16,
            width: bounds.width - 16 - avatarkaImageView.frame.maxX - 16,
            height: 40
        )
        
        // фрейм кнопки Set
        setStatusBatton.frame = CGRect(
            x: 16,
            y: setStatusField.frame.maxY + 16,
            width: bounds.width - 32,
            height: 50
        )
        
    }
    
    @objc func showBattonPressed() {
        showStatusBatton.isHidden = true
        setStatusField.isHidden = false
        setStatusBatton.isHidden = false
        //setStatusField.becomeFirstResponder()
        print(setStatusField.text ?? "")
    }
    
    @objc func setBattonPressed() {
        setStatusBatton.isHidden = true
        setStatusField.isHidden = true
        showStatusBatton.isHidden = false
        //setStatusField.resignFirstResponder()
        if(setStatusField.text == "") {
                statusLabel.text = "Waiting for something..."
        }
        else {
            statusLabel.text = setStatusField.text
        }
        
        print(setStatusField.text ?? "")
    }
}
