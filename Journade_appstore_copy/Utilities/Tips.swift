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
        Text("You can see your keep journals here.")
    }
}
struct SendButtonTip: Tip {
    var title: Text {
        Text("Two options to send!")
    }
    
    var message: Text? {
        Text("You can keep your journal encrypted in Calender or fade it.")
    }
}
struct CalenderSaveJournalTip: Tip {
    var title: Text {
        Text("your journal here!")
    }
    
    var message: Text? {
        Text("click any date in calender to see your journals on that day.")
    }
}
