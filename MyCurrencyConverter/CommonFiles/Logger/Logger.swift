//
//  Logger.swift
//  GitHubChecker
//
//  Created by Mykola Kondratyuk on 2/14/21.
//  Copyright © 2021 Mykola Kondratyuk  All rights reserved.
//

import Foundation

struct log {    // swiftlint:disable:this type_name
    private init() {}

    private static func log(
        level: Level,
        message: @autoclosure () -> String,
        pathToFile: String,
        line: Int,
        function: String
    ) {
        #if DEBUG
        let fileName = (pathToFile as NSString).lastPathComponent
        let threadName = Thread.current.isMainThread ?  "[main]" : "[background]"
        print(
            level.icon,
            Date().formattedNow,
            "thread: \(threadName)",
            "<\(line)>",
            fileName,
            function,
            message()
        )
        #endif
    }
}

// MARK: - Log level

private extension log {

    enum Level {
        case debug
        case info
        case error
        case network

        var icon: String {
            switch self {
            case .debug:
                return "👁"
            case .info:
                return "ℹ️"
            case .error:
                return "🤬"
            case .network:
                return "📡"
            }
        }
    }
}

extension log {

    static func debug(
        _ message: @autoclosure () -> String,
        pathToFile: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(
            level: .debug,
            message: message(),
            pathToFile: pathToFile,
            line: line,
            function: function
        )
    }

    static func info(
        _ message: @autoclosure () -> String,
        pathToFile: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(
            level: .info,
            message: message(),
            pathToFile: pathToFile,
            line: line,
            function: function
        )
    }

    static func mark(
        pathToFile: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(
            level: .info,
            message: "",
            pathToFile: pathToFile,
            line: line,
            function: function
        )
    }

    static func error(
        _ message: @autoclosure () -> String,
        pathToFile: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(
            level: .error,
            message: message(),
            pathToFile: pathToFile,
            line: line,
            function: function
        )
    }

    static func network(
        _ message: @autoclosure () -> String,
        pathToFile: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(
            level: .network,
            message: message(),
            pathToFile: pathToFile,
            line: line,
            function: function
        )
    }
}
