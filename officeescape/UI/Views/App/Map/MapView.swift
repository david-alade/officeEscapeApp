//
//  MapView.swift
//  officeescape
//
//  Created by David Alade on 6/28/24.
//

import SwiftUI
import MapKit

struct EventsMapView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.annotations) { annotation in
            MapMarker(coordinate: annotation.coordinate, tint: .red)
        }
    }
}

