//
//  Util+Thread.swift
//  Components
//
//  Created by lidong on 2023/1/30.
//

import Foundation


/*
   保证代码在主线程中运行，不在主线程中运行 代码会assert
 */

public extension Thread{
    static func forceMainThreadRunning(){
        if !Thread.current.isMainThread{
            assert(false,"not is running in main thread")
        }
    }
}


