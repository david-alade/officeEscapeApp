//
//  ShareSheet.swift
//  bibite
//
//  Created by David Alade on 11/12/23.
//

import SwiftUI

// ShareSheet SwiftUI view to wrap UIActivityViewController

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
