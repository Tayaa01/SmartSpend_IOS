//
//  SettingsView.swift
//  SMARTSPEND
//
//  Created by yassmine zammali on 2/12/2024.
//

import SwiftUI

struct settingsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Section Profil
                SettingsSection(title: "Profile", items: [
                    SettingsItem(title: "Edit Profile", icon: "pencil", action: {}),
                    SettingsItem(title: "Change Password", icon: "lock", action: {}),
                    SettingsItem(title: "Log out", icon: "arrow.right.circle", action: {})
                ])
                
                // Section Notifications
                SettingsSection(title: "Notifications", items: [
                    SettingsItem(title: "Push Notifications", icon: "bell", action: {}),
                    SettingsItem(title: "Email Notifications", icon: "envelope", action: {}),
                    SettingsItem(title: "App Notifications", icon: "app.badge.fill", action: {})
                ])
                
                // Section Security
                SettingsSection(title: "Security", items: [
                    SettingsItem(title: "Two Factor Authentication", icon: "shield.lefthalf.fill", action: {}),
                    SettingsItem(title: "Change PIN", icon: "lock.shield", action: {}),
                    SettingsItem(title: "Security Questions", icon: "questionmark.circle", action: {})
                ])
                
                // Section About
                SettingsSection(title: "About", items: [
                    SettingsItem(title: "Version", icon: "app.fill", action: {}),
                    SettingsItem(title: "Privacy Policy", icon: "doc.plaintext", action: {}),
                    SettingsItem(title: "Terms of Service", icon: "doc.text", action: {}),
                    SettingsItem(title: "Contact Us", icon: "phone.fill", action: {})
                ])
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Settings")
    }
}

struct SettingsSection: View {
    var title: String
    var items: [SettingsItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.purple)
                .padding(.bottom, 5)
            
            ForEach(items, id: \.title) { item in
                item
            }
        }
    }
}

struct SettingsItem: View {
    var title: String
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.leading, 10)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        settingsView()
    }
}
