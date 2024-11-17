//
//  journadeWidgetBundle.swift
//  journadeWidget
//
//  Created by Leen Almejarri on 15/05/1446 AH.
//

import WidgetKit
import SwiftUI

@main
struct journadeWidgetBundle: WidgetBundle {
    var body: some Widget {
        JournadeWidget()
        journadeWidgetControl()
        journadeWidgetLiveActivity()
    }
}
