//
//  AppIntent.swift
//  Journade_appstore_copy
//
//  Created by Leen Almejarri on 10/05/1446 AH.
//

import Foundation
import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
 
    
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "quick thought:", default: "💭")
    var favoriteEmoji: String

}
