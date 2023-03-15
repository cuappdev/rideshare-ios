//
//  ReuqestTableViewCell.swift
//  Scoop
//
//  Created by Tiffany Pan on 3/8/23.
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    
    // MARK: Views
    private let profileImageView = UIImageView()
    private let requestDetailLabel = UILabel()
    private let acceptButton = UIButton()
    private let declineButton = UIButton()
    
    private var requestStatus: Bool
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // TODO: Ask for help. Need to figure out how to get this variable to change within the configure function
        self.requestStatus = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        if requestStatus {
            // Display only the profile picture + request info.
            setupProfilePictureView()
            setupRequestDetailLabel()
        } else {
            // Give the user the option to either accept/deny the pending request.
            setupProfilePictureView()
            setupRequestDetailLabel()
            setupDeclineButton()
            setupAcceptButton()
        }
    }

    
    private func setupProfilePictureView() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    private func setupRequestDetailLabel() {
        requestDetailLabel.font = .systemFont(ofSize: 16)
        requestDetailLabel.lineBreakMode = .byWordWrapping
        requestDetailLabel.numberOfLines = 0
        contentView.addSubview(requestDetailLabel)
        
        requestDetailLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(12)
        }
    }
    
    private func setupDeclineButton() {
        // Source: https://sarunw.com/posts/new-way-to-style-uibutton-in-ios15/
        // This button setup code with configurations can definitely be refactored in a future PR
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.bordered()
            configuration.baseForegroundColor = UIColor.scoopGreen
            configuration.baseBackgroundColor = UIColor.white
            configuration.background.strokeColor = UIColor.scoopGreen
            configuration.title = "Decline"
            configuration.titleAlignment = .center
            configuration.background.cornerRadius = 10
            declineButton.configuration = configuration
        } else {
            // Fallback on earlier versions
            declineButton.backgroundColor = UIColor.white
            declineButton.setTitle("Decline", for: .normal)
            declineButton.setTitleColor(UIColor.scoopGreen, for: .normal)
            declineButton.layer.cornerRadius = 10
            declineButton.contentHorizontalAlignment = .center
        }
        
        declineButton.addTarget(self, action: #selector(denyRequest), for: .touchUpInside)
        contentView.addSubview(declineButton)
        declineButton.snp.makeConstraints { make in
            make.leading.equalTo(requestDetailLabel.snp.leading)
            make.width.equalTo(127)
            make.height.equalTo(37)
            make.top.equalTo(requestDetailLabel.snp.bottom).offset(10)
        }
    }
    
    private func setupAcceptButton() {
        // Source: https://sarunw.com/posts/new-way-to-style-uibutton-in-ios15/
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.baseForegroundColor = UIColor.white
            configuration.baseBackgroundColor = UIColor.scoopGreen
            configuration.title = "Accept"
            configuration.titleAlignment = .center
            configuration.background.cornerRadius = 10
            acceptButton.configuration = configuration
        } else {
            // Fallback on earlier versions
            acceptButton.setTitle("Accept", for: .normal)
            acceptButton.setTitleColor(.white, for: .normal)
            acceptButton.layer.cornerRadius = 10
            acceptButton.backgroundColor = UIColor.scoopGreen
        }
        
        acceptButton.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
        contentView.addSubview(acceptButton)
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(declineButton.snp.top)
            make.leading.equalTo(declineButton.snp.trailing).offset(15)
            make.width.equalTo(127)
            make.height.equalTo(37)
        }
    }
    
    @objc func denyRequest() {
        // TODO: Networking
//        NetworkManager.shared.handleRideRequest(requestID: <#T##Int#>, approved: <#T##Bool#>, completion: <#T##(Result<RequestResponse, Error>) -> Void#>)
        // Configure the cell to change 
    }

    @objc func acceptRequest() {
        // TODO: Networking
//        NetworkManager.shared.handleRideReques t(requestID: <#T##Int#>, approved: <#T##Bool#>, completion: <#T##(Result<RequestResponse, Error>) -> Void#>)
    }
    
    func configure(request: RequestResponse, status: Bool) {
        // will replace with information from actual model when backend models are confirmed
        let boldAttribute = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        let boldedName = NSMutableAttributedString(string: "Lia C", attributes: boldAttribute)
        let regularDescription = NSMutableAttributedString(string: " requests to join Drive to New York, NY")
        boldedName.append(regularDescription)
        requestDetailLabel.attributedText = boldedName
        profileImageView.image = UIImage(named: "notification") //Change to UIImage from URL
        requestStatus = status
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
