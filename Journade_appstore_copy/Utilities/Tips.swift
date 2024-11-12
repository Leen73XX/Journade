//
//  Tips.swift
//  Journade_appstore_copy
//
//  Created by Leen Almejarri on 09/05/1446 AH.
//

import Foundation
import TipKit

struct CalenderTip: Tip {
    var title: Text {
        Text("Calender here!")
    }
    
    var message: Text? {
        Text("You can see your keep journals here")
    }
}
struct SendButtonTip: Tip {
    var title: Text {
        Text("Two options to send !")
    }
    
    var message: Text? {
        Text("you can keep your journal encrypted in calender or fade it")
    }
}