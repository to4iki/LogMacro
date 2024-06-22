import Foundation
import OSLog

private let subsystem = Bundle.main.bundleIdentifier ?? ""

public enum Log {
  public static let `default` = Logger(subsystem: subsystem, category: LogCategory.default.rawValue)
  public static let tracking = Logger(subsystem: subsystem, category: LogCategory.tracking.rawValue)
  public static let network = Logger(subsystem: subsystem, category: LogCategory.network.rawValue)
}

public enum LogCategory: String {
  case `default`
  case tracking
  case network
}

public enum LogLevel: Int, Comparable {
  case debug = 0
  case warn = 1
  case fault = 2

  public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

public enum LogMessage {
  /// [File.swift:112] function > "message"
  public static func make(_ message: String, file: String = #file, function: String = #function, line: Int = #line) -> String {
    let simpleFileName = file.components(separatedBy: "/").last ?? file
    return "[\(simpleFileName):\(line)] \(function) > " + message
  }
}
