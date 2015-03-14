//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Alexander Ivanov on 28/02/15.
//  Copyright (c) 2015 alex_ivanov. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL?, title: String?) {
        self.filePathUrl = filePathUrl!
        self.title = title!
    }
}