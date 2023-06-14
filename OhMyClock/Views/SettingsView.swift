//
//  SettingsView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @State var rowHeight = 65.0
    @Environment(\.openURL) var openURL
    @Environment(\.requestReview) var requestReview
    @State var emailAlert : Bool = false
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            np_black
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    
                    // MARK: "Share App"
                    Button(action: {
                        shareSheet()
                    }, label: {
                        VStack(spacing: 10) {
                            Image("share")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(5)
                                .foregroundColor(np_white)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(np_white)
                                }
                                .padding(5)
                            
                            Text("Share")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                    })
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding()
                
                Spacer()
            }
            
            Spacer()
            
            // MARK: Logo
            VStack(alignment: .center) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(np_white)
                
                Text("Oh My Clock")
                    .font(.title)
                    .fontWeight(.light)
                    .kerning(5)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                
                Text("by: Appè Latte")
                    .font(.footnote)
                    .fontWeight(.thin)
                    .kerning(9.5)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                
                // MARK: App Version
                HStack(spacing: 10) {
                    Text("App Version:")
                        .font(.caption)
                        .fontWeight(.thin)
                        .kerning(5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Text("\(UIApplication.appVersion!)")
                        .font(.caption)
                        .fontWeight(.thin)
                        .kerning(5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 50)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 20) {
                
                Spacer()
                
                // MARK: Settings
                HStack {
                    Label("Information", systemImage: "info.bubble")
                        .font(.caption)
                        .fontWeight(.bold)
                        .kerning(5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Spacer()
                }
                .frame(width: screenWidth - 30)
                .padding()
                
                // MARK: "Legal Source"
                Button(action: {
                    openURL(URL(string: "https://weatherkit.apple.com/legal-attribution.html")!)
                }, label: {
                    HStack(spacing: 10) {
                        Image("cloud")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .foregroundColor(np_white)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(np_white)
                                
                            }
                            .padding(5)
                        
                        HStack {
                            Text("Weather Data Source")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Spacer()
                        }
                        
                        Image(systemName: "chevron.right")
                    }
                })
                .padding(.horizontal, 20)
                
                Divider()
                
                // MARK: "Contact Developer"
                Button(action: {
                    emailAlert.toggle()
                }, label: {
                    HStack(spacing: 10) {
                        Image("message")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .foregroundColor(np_white)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(np_white)
                            }
                            .padding(5)
                        
                        HStack {
                            Text("Contact Us")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Spacer()
                        }
                        
                        Image(systemName: "chevron.right")
                    }
                })
                .padding(.horizontal, 20)
                
                Divider()
                
                // MARK: "Developer Website"
                Button(action: {
                    openURL(URL(string: "https://www.appe-latte.ca")!)
                }, label: {
                    HStack(spacing: 10) {
                        Image("country")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .foregroundColor(np_white)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(np_white)
                            }
                            .padding(5)
                        
                        HStack {
                            Text("Visit our website")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Spacer()
                        }
                        
                        Image(systemName: "chevron.right")
                    }
                })
                .padding(.horizontal, 20)
                
                Divider()
                
                // MARK: "Write A Review"
                Button(action: {
                    requestReview()
                }, label: {
                    HStack(spacing: 10) {
                        Image("like")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .foregroundColor(np_white)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(np_white)
                            }
                            .padding(5)
                        
                        HStack {
                            Text("Write A Review")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Spacer()
                        }
                        
                        Image(systemName: "chevron.right")
                    }
                })
                .padding(.horizontal, 20)
                
                Divider()
            }
            .padding(.bottom, 20)
            
            Spacer()
            
        }
        .alert("Email us to discuss your app development needs.", isPresented: $emailAlert, actions: {
            Button(action: {
                mailto("hello@appe-latte.ca")
            }, label: {
                Label("Email", systemImage: "envelope.fill")
            })
            Button("Cancel", role: .cancel, action: {})
        })
    }
    
    // MARK: "Email" function
    func mailto(_ email: String) {
        let mailto = "mailto:\(email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(mailto ?? "")
        if let url = URL(string: mailto!) {
            openURL(url)
        }
    }
}

// MARK: "App Version" extension
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

// MARK: "Share sheet" function
func shareSheet() {
    guard let data = URL(string: "https://apps.apple.com/us/app/ohmyclock/id1667124410") else { return }
    let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
}
