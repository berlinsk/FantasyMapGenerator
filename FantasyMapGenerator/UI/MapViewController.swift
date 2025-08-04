//
//  ViewController.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import UIKit

class MapViewController: UIViewController {

    private let imageView = UIImageView()
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        label.text = "tap map to regenerate"
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        regenerateMap()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(regenerateMap))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc private func regenerateMap() {
        imageView.image = MapGenerator.generate(size: CGSize(width: 512, height: 512))
    }
}
