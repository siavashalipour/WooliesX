//
//  MainViewTableViewCell.swift
//  WooliesX
//
//  Created by Siavash on 24/9/20.
//  Copyright © 2020 Siavash. All rights reserved.
//

import SnapKit
import Kingfisher
import RxSwift

final class MainViewTableViewCell: UITableViewCell {
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.left.top.equalTo(16)
            make.bottom.equalTo(-16)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp.right).offset(8)
            make.top.equalTo(imgView)
            make.right.equalTo(-16)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
    }
    
    func config(with data: ApiResponse) {
        titleLabel.text = data.breeds?.first?.name ?? ""
        subLabel.text = data.breeds?.first?.lifeSpan ?? ""
        guard let imgUrl = data.imageURL, let url = URL(string: imgUrl) else { return }
        imgView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
    }
}
