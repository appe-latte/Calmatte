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
    
    var body: some View {
        let screenHeight = UIScreen.main.bounds.height
        
        ZStack {
            VStack(alignment: .center) {
                Form {
                    //                    Section(header: Text("Appearance")) {
                    //
                    //                        // MARK: "Buy Coffee"
                    //
                    //                        NavigationLink(destination: SettingsView()){
                    //                            Image("log-out")
                    //                                .resizable()
                    //                                .frame(width: 30, height: 30)
                    //                                .foregroundColor(.red)
                    //
                    //                            HStack {
                    //                                Text("Light / dark Mode")
                    //                                    .font(.headline)
                    //                                    .fontWeight(.semibold)
                    //                                    .foregroundColor(np_black)
                    //
                    //                                Spacer()
                    //                            }
                    //                        }
                    //
                    //
                    //                        // MARK: "Write A Review"
                    //
                    //                        NavigationLink(destination: SettingsView()){
                    //                            Image("log-out")
                    //                                .resizable()
                    //                                .frame(width: 30, height: 30)
                    //                                .foregroundColor(.red)
                    //
                    //                            HStack {
                    //                                Text("Write A Review")
                    //                                    .font(.caption)
                    //                                    .fontWeight(.semibold)
                    //                                    .foregroundColor(np_black)
                    //
                    //                                Spacer()
                    //                            }
                    //                        }
                    //
                    //                        // MARK: "Share App"
                    //
                    //                        NavigationLink(destination: SettingsView()){
                    //                            Image("log-out")
                    //                                .resizable()
                    //                                .frame(width: 30, height: 30)
                    //                                .foregroundColor(.red)
                    //
                    //                            HStack {
                    //                                Text("Share This App")
                    //                                    .font(.caption)
                    //                                    .fontWeight(.semibold)
                    //                                    .foregroundColor(np_black)
                    //
                    //                                Spacer()
                    //                            }
                    //                        }
                    //                    }
                    
                    // MARK: "Developer" Section
                    
                    Section(header: Text("Developer")) {
                        
                        // MARK: "Buy Coffee"
                        
                        Button(action: {
                            openURL(URL(string: "https://www.buymeacoffee.com/appe.latte")!)
                        }, label: {
                            HStack {
                                Image("usd")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                                    .foregroundColor(np_white)
                                    .background(Color(uiColor: .systemYellow))
                                    .clipShape(Circle())
                                
                                HStack {
                                    Text("Buy A Coffee")
                                        .font(.headline)
                                        .foregroundColor(np_black)
                                    
                                    Spacer()
                                }
                            }
                        })
                        
                        // MARK: "Contact Developer"
                        
                        Button(action: {
                            emailAlert.toggle()
                        }, label: {
                            HStack {
                                Image("message")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                                    .foregroundColor(np_white)
                                    .background(Color(uiColor: .systemIndigo))
                                    .clipShape(Circle())
                                
                                HStack {
                                    Text("Contact Developer")
                                        .font(.headline)
                                        .foregroundColor(np_black)
                                    
                                    Spacer()
                                }
                            }
                        })
                        
                        // MARK: "Developer Website"
                        
                        Button(action: {
                            openURL(URL(string: "https://www.appe-latte.ca")!)
                        }, label: {
                            HStack {
                                Image("country")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                                    .foregroundColor(np_white)
                                    .background(Color(uiColor: .systemMint))
                                    .clipShape(Circle())
                                
                                Text("Visit Our Website")
                                    .font(.headline)
                                    .foregroundColor(np_black)
                                    .foregroundColor(np_black)
                                
                                Spacer()
                            }
                        })
                        
                        // MARK: "Write A Review"
                        
                        Button(action: {
                            requestReview()
                        }, label: {
                            HStack {
                                Image("like")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                                    .foregroundColor(np_white)
                                    .background(Color(uiColor: .systemCyan))
                                    .clipShape(Circle())
                                
                                HStack {
                                    Text("Write A Review")
                                        .font(.headline)
                                        .foregroundColor(np_black)
                                        .foregroundColor(np_black)
                                    
                                    Spacer()
                                }
                            }
                        })
                        
                        // MARK: "Share App"
                        
                        Button(action: {
                            shareSheet()
                        }, label: {
                            HStack {
                                Image("share")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                                    .foregroundColor(np_white)
                                    .background(np_red)
                                    .clipShape(Circle())
                                
                                HStack {
                                    Text("Share This App")
                                        .font(.headline)
                                        .foregroundColor(np_black)
                                    
                                    Spacer()
                                }
                            }
                        })
                    }
                    .environment(\.defaultMinListRowHeight, rowHeight)
                    
                    // MARK: "App Version"
                    HStack {
                        Spacer()
                        
                        Text("App Version: \(UIApplication.appVersion!)")
                            .font(.footnote)
                            .foregroundColor(np_black)
                        
                        Spacer()
                    }
                }
            }
            
            Spacer()
            
        }
        .alert("Got an app idea?", isPresented: $emailAlert, actions: {
            Button(action: {
                mailto("stanford@appe-latte.ca")
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
