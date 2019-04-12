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

        let body:[String : Any] = ["Flag": stringParam.flag!,
                    "Question": stringParam.question!,
        "Sentence": stringParam.sentence!,
        "Leave": stringParam.leave!,
        "Type": stringParam.type!,
        "Date": stringParam.date!,
        ]
        return body
    }
}
struct ConfirmClaim {
    static func requestBody(stringParam:Dictionary<String,Any>) -> [String: Any] {
        
        let body:[String : Any] = ["data": stringParam,
                                   ]
        return body
    }
}


