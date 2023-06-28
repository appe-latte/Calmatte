//
//  PlaybackControlButton.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI

struct PlaybackControlButton: View {
    var systemName : String = "Play"
    var fontSize : CGFloat = 24
    var color : Color = np_white
    var action :  () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: fontSize))
                .foregroundColor(color)
        }
    }
}
