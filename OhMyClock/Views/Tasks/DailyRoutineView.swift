//
//  DailyRoutineView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2025-03-05.
//

import SwiftUI

struct DailyRoutineView: View {
    var body: some View {
        // MARK: Displays the Routine Cards
        if routineManager.routines.isEmpty {
            Text("No routines to display")
                .padding()
        } else {
            ForEach(routineManager.routines) { routine in
                RoutineCardView(routineManager: routineManager, routine: routine)
                    .padding()
            }
        }
    }
}

#Preview {
    DailyRoutineView()
}
