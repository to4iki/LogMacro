import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LogMacroImplementation)
  import LogMacroImplementation

  let testMacros: [String: Macro.Type] = [
    "logDebug": LogDebugMacro.self,
    "logWarn": LogWarnMacro.self,
    "logFault": LogFaultMacro.self
  ]
#endif

final class LogMacroTests: XCTestCase {
  func testLogDebug() throws {
    #if canImport(LogMacroImplementation)
      assertMacroExpansion(
        """
        #logDebug("message")
        """,
        expandedSource: 
        """
        ({
          let level = LogLevel.debug
          guard LogProcess.shared.canLogging(level: level) else {
            return
          }

          let newMessage = LogProcess.shared.replaceMessage(from: "\\("message")", level: level)
          Log.default
            .debug("\\(LogMessage.make(newMessage, file: #file, function: #function, line: #line))")

          LogProcess.shared.executePostAction(message: "message", level: level, file: #file, function: #function, line: #line)
            })()
        """,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testLogWarn() throws {
    #if canImport(LogMacroImplementation)
      assertMacroExpansion(
        """
        #logWarn("message", category: .tracking)
        """,
        expandedSource:
        """
        ({
          let level = LogLevel.warn
          guard LogProcess.shared.canLogging(level: level) else {
            return
          }

          let newMessage = LogProcess.shared.replaceMessage(from: "\\("message")", level: level)
          Log.tracking
            .warning("\\(LogMessage.make(newMessage, file: #file, function: #function, line: #line))")

          LogProcess.shared.executePostAction(message: "message", level: level, file: #file, function: #function, line: #line)
            })()
        """,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testLogFault() throws {
    #if canImport(LogMacroImplementation)
      enum MyError: Error {
        case unknown
      }
      assertMacroExpansion(
        """
        #logFault(MyError.unknown, category: .network)
        """,
        expandedSource:
        """
        ({
          let level = LogLevel.fault
          guard LogProcess.shared.canLogging(level: level) else {
            return
          }

          let newMessage = LogProcess.shared.replaceMessage(from: "\\(MyError.unknown)", level: level)
          Log.network
            .fault("\\(LogMessage.make(newMessage, file: #file, function: #function, line: #line))")

          LogProcess.shared.executePostAction(message: MyError.unknown, level: level, file: #file, function: #function, line: #line)
            })()
        """,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }
}
