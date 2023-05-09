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
import WeatherKit

struct MainView: View {
    @EnvironmentObject var timerModel : TimerModel
    
    var body: some View {
        NavigationView {
            ClockView()
                .navigationBarHidden(true)
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

