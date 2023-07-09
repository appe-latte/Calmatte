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
                    // MARK: "Developer Website"
                    Button(action: {
                        openURL(URL(string: "https://www.appe-latte.ca")!)
                    }, label: {
                        HStack(spacing: 5) {
                            Image("country")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(np_white)
                            
                                Text("our website")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                        }
                    })

                    Spacer()
                    
                    // MARK: "Share App"
                    Button(action: {
                        shareSheet()
                    }, label: {
                            HStack {
                                Image("share")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(np_white)
                                
                                Text("Share")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                            }
                    })
                }
                .padding()
                
                Spacer()
            }
            
            Spacer()
            
            // MARK: Logo
            VStack(alignment: .center, spacing: 3) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(np_purple)
                    .frame(width: 180, height: 210)
                
                Text("Developed with \(Image(systemName: "heart.fill")) by: Appè Latte")
                    .font(.system(size: 10))
                    .fontWeight(.thin)
                    .kerning(4)
                    .textCase(.uppercase)
                    .foregroundColor(np_purple)
                
                // MARK: App Version + Build Number
                HStack(spacing: 10) {
                    Text("App Version:")
                        .font(.system(size: 9.5))
                        .fontWeight(.thin)
                        .kerning(5)
                        .textCase(.uppercase)
                        .foregroundColor(np_purple)
                    
                    
                    if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                        
                        Text("\(UIApplication.appVersion!) (\(buildNumber))")
                            .font(.system(size: 9.5))
                            .fontWeight(.regular)
                            .kerning(9.5)
                            .textCase(.uppercase)
                            .foregroundColor(np_purple)
                    }
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
                    Label("Settings", systemImage: "info.bubble")
                        .font(.caption)
                        .fontWeight(.bold)
                        .kerning(5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Spacer()
                }
                .frame(width: screenWidth - 30)
                .padding()
                
                // MARK: "Face ID"
                Button(action: {
                    emailAlert.toggle()
                }, label: {
                    HStack(spacing: 10) {
                        Image("scan")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5)
                            .foregroundColor(np_white)
                        
                        HStack {
                            Text("secure with faceid")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .kerning(5)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            
                            Spacer()
                        }
                    }
                })
                .padding(.horizontal, 20)
                
                Divider()
                
                // MARK: "Legal Source"
                Button(action: {
                    openURL(URL(string: "https://weatherkit.apple.com/legal-attribution.html")!)
                }, label: {
                    HStack(spacing: 10) {
                        Image("note")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5)
                            .foregroundColor(np_blue)
                        
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
                        Image("chat")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5)
                            .foregroundColor(np_green)
                        
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
                
                // MARK: "Write A Review"
                Button(action: {
                    requestReview()
                }, label: {
                    HStack(spacing: 10) {
                        Image("review")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5)
                            .foregroundColor(np_orange)
                        
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
