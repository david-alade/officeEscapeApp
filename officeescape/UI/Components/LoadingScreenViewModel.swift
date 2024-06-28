//
//  LoadingScreenViewModel.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import Foundation
import SwiftUI

struct LoadingScreenView: View {
    @ObservedObject var viewModel: LoadingScreenViewModel
    
    var body: some View {
        Text("LOADING")
    }
}

final class LoadingScreenViewModel: ViewModel {
    @Published var stageText: String?
    
    func setup(text: String) -> Self {
        self.stageText = text
        return self
    }
    
    func changeText(to text: String) {
        self.stageText = text
    }
}
