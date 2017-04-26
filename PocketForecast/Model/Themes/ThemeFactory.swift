////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class ThemeFactory : NSObject {
    
    fileprivate var _sequentialTheme : Theme?
    fileprivate(set) var themes : Array<Theme>
    
    init(themes : Array<Theme>) {
        self.themes = themes
        assert(themes.count > 0, "ThemeFactory requires at least one theme in collection")
    }
    
    open func sequentialTheme() -> Theme {
        if (_sequentialTheme == nil) {
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory : NSString = paths[0] as NSString!
            let indexFileName = documentsDirectory.appendingPathComponent("PF_CURRENT_THEME_INDEX")
            var index = (try? NSString(contentsOfFile: indexFileName, encoding: String.Encoding.utf8.rawValue))?.integerValue
            if (index == nil || index > themes.count - 1) {
                index = 0
            }
            _sequentialTheme = themes[index!]
            do {
                try NSString(format: "%i", (index! + 1)).write(toFile: indexFileName, atomically: false, encoding: String.Encoding.utf8.rawValue)
            } catch _ {
            }
        }
        return _sequentialTheme!
    }
    

    
}
