//
//  IntelligentView.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import SwiftUI
import MarkdownUI

struct IntelligentView: View {
    @ObservedObject var viewModel: IntelligentViewModel
    @State private var query: String = ""

    var body: some View {
        VStack {
            Text("Event Finding Ai")
                .font(.title)
            
            TextField("Enter your query", text: $query, onCommit: {
                viewModel.askQuestion(query)
                UIApplication.shared.hideKeyboard()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Button(action: {
                viewModel.askQuestion(query)
                UIApplication.shared.hideKeyboard()
            }) {
                Text("Ask")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.aiState == .loading || viewModel.aiState == .streaming)
            .opacity((viewModel.aiState == .loading || viewModel.aiState == .streaming) ? 0.5 : 1)
            
            Spacer()
            
            if viewModel.aiState == .loading || viewModel.aiState == .streaming {
                ProgressView()
                    .padding()
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        Markdown(viewModel.responseString)
                            .padding()
                        
                        // Adding an empty view with id "bottom"
                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                }
                .onChange(of: viewModel.responseString) { _ in
                    withAnimation {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .padding()
    }
}
