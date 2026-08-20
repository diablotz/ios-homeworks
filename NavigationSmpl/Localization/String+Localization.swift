//
//  String+Localization.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 20/08/26.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func getLikesString(_ likes: Int) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String.localizedStringWithFormat(format, likes)
    }
    
    func getViewsString(_ views: Int) -> String {
        let format = NSLocalizedString(self, comment: "")
        return String.localizedStringWithFormat(format, views)
    }
}
