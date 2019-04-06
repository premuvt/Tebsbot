//
//  ParameterManager.swift
//  Tebsbot
//
//  Created by uvionics on 06/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
struct ConfirmLeave {
    static func requestBody(stringParam:StringData) -> [String: Any] {

        let body:[String : Any] = ["Flag": stringParam.flag == 1 ? true :false  ,
                    "Question": stringParam.question,
        "Sentence": stringParam.sentence,
        "Leave": stringParam.leave,
        "Type": stringParam.type,
        "Date": stringParam.date,
        ]
        return body
    }
}


