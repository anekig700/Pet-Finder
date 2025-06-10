//
//  MapView.swift
//  PetFinder
//
//  Created by Kotya on 10/06/2025.
//

import Foundation
import UIKit
import MapKit

final class MapView: MKMapView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        heightAnchor.constraint(equalToConstant: 150).isActive = true
        layer.cornerRadius = UIConstants.CornerRadiuses.block
        isScrollEnabled = false
        isZoomEnabled = false
        isRotateEnabled = false
        isPitchEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
