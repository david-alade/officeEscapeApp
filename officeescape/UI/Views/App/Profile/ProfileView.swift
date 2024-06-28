//
//  ProfileView.swift
//  officeescape
//
//  Created by David Alade on 6/27/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingEnterInterests = false
    @State private var newInterest: String = ""
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding()
                
                Text(viewModel.user.profile.name)
                    .font(.title)
                    .bold()
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("About Me")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                Text(viewModel.user.profile.bio)
                    .padding(.bottom, 10)
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("Interests")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                HStack {
                    ForEach(viewModel.user.profile.interests, id: \.self) { interest in
                        InterestTag(title: interest)
                    }
                    .padding(.bottom, 5)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.showingEnterInterests = true
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("CHANGE")
                        }
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.blue, lineWidth: 1))
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .showPopup(isShowing: $showingEnterInterests) {
            HStack {
                TextField("Enter new interest", text: $newInterest)
                    .padding()
                
                Button {
                    viewModel.updateInterests(interest: newInterest)
                    newInterest = ""
                    showingEnterInterests = false
                } label: {
                    Image(systemName: "plus.app")
                }
                .padding()
                .disabled(newInterest.count == 0)
                .opacity(newInterest.count == 0 ? 0.5 : 1)
            }
        }
    }
}

struct InterestTag: View {
    let title: String
    
    var body: some View {
        Text(title)
            .padding(10)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(authedUserService: MockAuthedUserService()))
}
