import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// A macro that outputs `Logger.debug` with formatting anywhere across modules.
public struct LogDebugMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {
    guard let message = node.arguments.first?.expression else {
      fatalError("Expected an argument")
    }

    let categoryArg = node.arguments.first(where: { $0.label?.text == "category" })
    let loggerExpr: ExprSyntax
    if let categoryExpr = categoryArg?.expression {
      loggerExpr = "Log\(categoryExpr)"
    } else {
      loggerExpr = "Log.default"
    }

    return """
    ({
      let level = LogLevel.debug
      guard LogProcess.shared.canLogging(level: level) else {
        return
      }

      let newMessage = LogProcess.shared.replaceMessage(from: "\\(\(message))", level: level)
      \(loggerExpr)
        .debug("\\(LogMessage.make(newMessage, file: #file, function: #function, line: #line))")

      LogProcess.shared.executePostAction(message: \(message), level: level, file: #file, function: #function, line: #line)
    })()
    """
  }
}
