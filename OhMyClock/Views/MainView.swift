//
//  MainView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @State var nightMode = false
    
    var body: some View {
        NavigationView {
            ClockView(nightMode: $nightMode)
                .navigationBarHidden(true)
                .preferredColorScheme(nightMode ? .dark : .light)
        }
    }
}

struct FlipView: View {
    
    init(viewModel: FlipViewModel) {
        self.viewModel = viewModel
    }
    
    @ObservedObject var viewModel: FlipViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                SingleFlipView(text: viewModel.newValue ?? "", type: .top)
                SingleFlipView(text: viewModel.oldValue ?? "", type: .top)
                    .rotation3DEffect(.init(degrees: self.viewModel.animateTop ? -90 : .zero),
                                      axis: (1, 0, 0),
                                      anchor: .bottom,
                                      perspective: 0.5)
            }
            
            // MARK: Separator
            
            np_black
                .frame(height: 1.5)
                .clipShape(RoundedRectangle(cornerRadius: 2))
            
            ZStack {
                SingleFlipView(text: viewModel.oldValue ?? "", type: .bottom)
                SingleFlipView(text: viewModel.newValue ?? "", type: .bottom)
                    .rotation3DEffect(.init(degrees: self.viewModel.animateBottom ? .zero : 90),
                                      axis: (1, 0, 0),
                                      anchor: .top,
                                      perspective: 0.5)
            }
        }
        .fixedSize()
    }
}

struct SingleFlipView: View {
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    init(text: String, type: FlipType) {
        self.text = text
        self.type = type
    }
    
    var body: some View {
        Text(text)
            .font(.custom("Helvetica-Bold", size: 100))
            .fontWeight(.heavy)
            .foregroundColor(np_black)
            .fixedSize()
            .padding(type.padding, -35)
            .frame(maxWidth: 50, maxHeight: 65)
            .padding(type.paddingEdges, 15)
            .clipped()
            .background(np_white)
            .cornerRadius(15)
            .padding(type.padding, -15.5)
            .clipped()
    }
    
    enum FlipType {
        case top
        case bottom
        
        var padding: Edge.Set {
            switch self {
            case .top:
                return .bottom
            case .bottom:
                return .top
            }
        }
        
        var paddingEdges: Edge.Set {
            switch self {
            case .top:
                return [.top, .leading, .trailing]
            case .bottom:
                return [.bottom, .leading, .trailing]
            }
        }
        
        var alignment: Alignment {
            switch self {
            case .top:
                return .bottom
            case .bottom:
                return .top
            }
        }
    }
    
    private let text: String
    private let type: FlipType
    
}

struct ClockView: View {
    @StateObject var weatherViewModel = WeatherViewModel()
    
    @Binding var nightMode : Bool
    
    let viewModel = ClockViewModel()
    
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    HStack {
                        VStack(spacing: 10) {
                            HStack {
                                Text(Date().formatted(.dateTime.month().day().year()))
                                    .font(.system(size: 28))
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .minimumScaleFactor(0.5)
                                    .textCase(.uppercase)
                                
                                Spacer()
                            }
                            
                            // MARK: "Morning / Afternoon / Evening"
                            HStack {
                                if Calendar.current.component(.hour, from: Date()) > 5 && Calendar.current.component(.hour, from: Date()) < 11 {
                                    Text("Good Morning")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .kerning(10)
                                        .textCase(.uppercase)
                                        .minimumScaleFactor(0.5)
                                } else if Calendar.current.component(.hour, from: Date()) > 11 && Calendar.current.component(.hour, from: Date()) < 13 {
                                    Text("Mid-day")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .kerning(10)
                                        .textCase(.uppercase)
                                        .minimumScaleFactor(0.5)
                                } else if Calendar.current.component(.hour, from: Date()) > 13 && Calendar.current.component(.hour, from: Date()) < 17 {
                                    Text("Good Afternoon")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .kerning(7)
                                        .textCase(.uppercase)
                                        .minimumScaleFactor(0.5)
                                } else if Calendar.current.component(.hour, from: Date()) > 17 && Calendar.current.component(.hour, from: Date()) < 22 {
                                    Text("Good Evening")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .kerning(10)
                                        .textCase(.uppercase)
                                        .minimumScaleFactor(0.5)
                                }
                                else {
                                    Text("Good Night")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .kerning(10)
                                        .textCase(.uppercase)
                                        .minimumScaleFactor(0.5)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(10)
                        .padding(.top, 30)
                        
                        Spacer(minLength: 0)
                        
                        // MARK: Toggle Day / Night
                        
                        VStack {
                            Button(action: {
                                nightMode.toggle()
                            }, label: {
                                Image(nightMode ? "sun" : "moon")
                                    .font(.headline)
                                    .foregroundColor(nightMode ? .black : .white)
                                    .padding(7)
                                    .background(Color.primary)
                                    .clipShape(Circle())
                            })
                            
                            Text("Day / Night")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .textCase(.uppercase)
                        }
                        .padding(.top, 30)
                    }
                    .padding()
                    
                    HStack(spacing: 15) {
                        FlipView(viewModel: viewModel.flipViewModels[0])
                        
                        FlipView(viewModel: viewModel.flipViewModels[1])
                        
                        FlipView(viewModel: viewModel.flipViewModels[2])
                        
                        FlipView(viewModel: viewModel.flipViewModels[3])
                    }
                    .frame(maxWidth: width - 20)
                    
                    HStack {
                        Spacer()
                        
                        // MARK: Time Zone
                        
                        HStack(spacing: 5) {
                            Text("Time Zone:")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                            
                            Text(weatherViewModel.timezone)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 35)
                    
                    Spacer(minLength: 0)
                    
                    // MARK: Weather Information
                    
                    ZStack {
                        np_white
                        
                        VStack(spacing: 25) {
                            HStack {
                                Text("Weather Information")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_black)
                                
                                Spacer(minLength: 0)
                            }
                            
                            HStack {
                                // MARK: Location
                                
                                VStack(spacing: 5) {
                                    Image("weather")
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .frame(width: 60, height: 60)
                                        .padding(25)
                                        .background(np_black)
                                        .clipShape(Circle())
                                        .foregroundColor(np_white)
                                    
                                    Text(weatherViewModel.title)
                                        .font(.custom("Helvetica-Bold", size: 30))
                                        .foregroundColor(np_black)
                                    
                                    Text(weatherViewModel.descriptionText)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_black)
                                }
                                
                                Spacer(minLength: 0)
                                
                                // MARK: Temperature
                                
                                VStack(spacing: 5) {
                                    Image("temperature")
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .frame(width: 60, height: 60)
                                        .padding(25)
                                        .background(np_black)
                                        .clipShape(Circle())
                                        .foregroundColor(np_white)
                                    
                                    
                                    Text(weatherViewModel.temp)
                                        .font(.custom("Helvetica-Bold", size: 30))
                                        .foregroundColor(np_black)
                                    
                                    Text("Feels like: \(weatherViewModel.feels_like)")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_black)
                                }
                            }
                            
                            // MARK: Location
                            
                            HStack {
                                VStack(spacing: 5) {
                                    Image("city")
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .frame(width: 60, height: 60)
                                        .padding(25)
                                        .background(np_black)
                                        .clipShape(Circle())
                                        .foregroundColor(np_white)
                                    
                                    Text("Calgary")
                                        .font(.custom("Helvetica-Bold", size: 30))
                                        .foregroundColor(np_black)
                                    
                                    Text("City")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_black)
                                }
                                
                                Spacer(minLength: 0)
                                
                                // MARK: Temperature
                                
                                VStack(spacing: 5) {
                                    Image("humidity")
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .frame(width: 60, height: 60)
                                        .padding(25)
                                        .background(np_black)
                                        .clipShape(Circle())
                                        .foregroundColor(np_white)
                                    
                                    Text(weatherViewModel.humidity)
                                        .font(.custom("Helvetica-Bold", size: 30))
                                        .foregroundColor(np_black)
                                    
                                    Text("Humidity")
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_black)
                                }
                            }
                            
                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: width / 1.25)
                        .padding(.top, 25)
                    }
                    .frame(maxWidth: width - 20, maxHeight: 650)
                    .cornerRadius(20)
                    .padding(.top, 20)
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
    }
    
    func getTime()->String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
