//
//  JournalWidgetBundle.swift
//  JournalWidget
//
//  Created by Leen Almejarri on 09/05/1446 AH.
//

import WidgetKit
import SwiftUI

@main
struct JournalWidgetBundle: WidgetBundle {
    var body: some Widget {
        JournalWidget()
        JournalWidgetControl()
        JournalWidgetLiveActivity()
    }
}
