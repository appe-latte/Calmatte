//
//  MainView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import Combine
import Alamofire
import SwiftyJSON
import CoreLocation

struct MainView: View {
    @State var nightMode = false
    @EnvironmentObject var timerModel : TimerModel
    
    var body: some View {
        NavigationView {
            //        ZStack {
            ClockView(nightMode: $nightMode)
                .navigationBarHidden(true)
                .preferredColorScheme(nightMode ? .dark : .light)
            //        }
            //        .frame(maxWidth: .infinity)
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
                .frame(height: 2.5)
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
            .clipShape(RoundedCorner(radius: 15))
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
    @EnvironmentObject var timerModel : TimerModel
    @State var city : String = ""
    
    @Binding var nightMode : Bool
    
    let viewModel = ClockViewModel()
    let locationFetch = LocationFetch()
    
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    HStack {
                        VStack(spacing: 10) {
                            // MARK: Date
                            
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
                                Text(greeting)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .kerning(10)
                                    .textCase(.uppercase)
                                    .minimumScaleFactor(0.5)
                                
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
                    
                    // MARK: Focus Timer
                    
                    VStack {
                        VStack(spacing: 10) {
                            HStack {
                                Text("Focus Timer")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_black)
                                
                                Spacer()
                                
                                Text(timerModel.timerValue)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .kerning(5)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_black)
                                    .animation(.none, value: timerModel.progress)
                            }
                            
                            GeometryReader { geo in
                                VStack(spacing: 5) {
                                    ZStack {
                                        Circle()
                                            .fill(np_white)
                                            .padding(-20)
                                        
                                        Circle()
                                            .trim(from: 0, to: timerModel.progress)
                                            .stroke(np_black.opacity(0.07), lineWidth: 40)
                                        
                                        // MARK: Shadow
                                        
                                        Circle()
                                            .stroke(Color(red: 24 / 255, green: 24 / 255, blue: 24 / 255), lineWidth: 5)
                                            .blur(radius: 5)
                                            .padding(-1)
                                        
                                        Circle()
                                            .fill(np_white)
                                        
                                        Circle()
                                            .trim(from: 0, to: timerModel.progress)
                                            .stroke(Color(red: 224 / 255, green: 20 / 255, blue: 76 / 255).opacity(0.9), lineWidth: 10)
                                        
                                        // MARK: Knob
                                        
                                        GeometryReader { geo_knob in
                                            let size = geo_knob.size
                                            
                                            Circle()
                                                .fill(np_white)
                                                .frame(width: 30, height: 30)
                                                .overlay(content: {
                                                    Circle()
                                                        .fill(np_red)
                                                        .padding(5)
                                                })
                                                .frame(width: size.width, height: size.height)
                                                .offset(x: size.height / 2)
                                                .rotationEffect(.init(degrees: timerModel.progress * 360))
                                        }
                                    }
                                    .padding(10)
                                    .frame(height: geo.size.width * 0.8)
                                    .rotationEffect(.init(degrees: -90))
                                    .animation(.easeInOut, value: timerModel.progress)
                                }
                                .onTapGesture(perform: {
                                    timerModel.progress = 0.5
                                })
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            }
                            
                            Spacer()
                            
                            // MARK: "Pause" button
                            HStack {
                                Spacer()
                                
                                VStack {
                                    Button {
                                        if timerModel.isStarted {
                                            
                                        } else {
                                            timerModel.addNewTimer = true
                                        }
                                    } label: {
                                        Image(systemName: !timerModel.isStarted ? "timer" :  "pause")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: 25, maxHeight: 25)
                                            .padding(5)
                                    }
                                    .padding(.vertical, 5)
                                    .foregroundColor(np_white)
                                    .frame(width: 45, height: 45)
                                    .background(np_black)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(np_white, style: StrokeStyle(lineWidth: 1))
                                            .padding(3)
                                    )
                                    
                                    Text("Pause")
                                        .font(.system(size: 12, weight: .medium))
                                }
                            }
                            .padding()
                        }
                        .frame(width: width / 1.25, height: height * 0.45)
                        .padding(.top, 25)
                    }
                    .frame(maxWidth: width - 20, maxHeight: height * 0.65)
                    .background(np_white)
                    .ignoresSafeArea()
                    .cornerRadius(20)
                    .padding(.top, 20)
                    .edgesIgnoringSafeArea(.bottom)
                }
                .overlay(content: {
                    ZStack {
                        np_black
                            .opacity(timerModel.addNewTimer ? 0.25 : 0)
                    }
                    .animation(.easeInOut, value: timerModel.addNewTimer)
                })
                .onAppear {
                    locationFetch.getCurrentLocation { location in
                        let lat = location.latitude
                        let lon = location.longitude
                        let apiKey = "AIzaSyDkXur7s6FqAHIB-kaPpGlIeaFHpTNhNPo"
                        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lon)&key=\(apiKey)"
                        AF.request(url).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let json = JSON(value)
                                let city = json["results"][0]["address_components"][3]["long_name"].stringValue
                                self.city = city
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: Timer bottom sheet
    
    @ViewBuilder
    func NewTimerView()->some View {
        VStack(spacing: 15) {
            Text("Add New Timer")
                .font(.footnote)
                .fontWeight(.bold)
                .kerning(5)
                .textCase(.uppercase)
                .foregroundColor(np_black)
                .padding(.top, 10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(np_red)
                .ignoresSafeArea()
        }
    }
    
    func getTime()->String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12:
            return "Mid-day"
        case 13..<17:
            return "Good Afternoon"
        case 17..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

