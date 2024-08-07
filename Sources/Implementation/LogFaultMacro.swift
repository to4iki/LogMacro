import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// A macro that outputs `Logger.fault` with formatting anywhere across modules.
public struct LogFaultMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {
    let messageArgs = node.arguments.filter { $0.label == nil }
    guard !messageArgs.isEmpty else {
      fatalError("Expected at least one message argument")
    }
    let messagesArray = messageArgs.map(\.expression)
    let messagesArraySyntax = ArrayExprSyntax(
      leftSquare: .leftSquareToken(),
      elements: ArrayElementListSyntax(
        messagesArray.enumerated().map { index, expr in
          let element = ArrayElementSyntax(expression: expr)
          return index == messagesArray.count - 1 ? element : ArrayElementSyntax(
            expression: expr,
            trailingComma: .commaToken()
          )
        }
      ),
      rightSquare: .rightSquareToken()
    )
    let combinedMessage = messagesArray.map { "\\(\($0))" }.joined(separator: " ")

    let categoryArg = node.arguments.first(where: { $0.label?.text == "category" })
    let loggerExpr: ExprSyntax
    if let categoryExpr = categoryArg?.expression {
      loggerExpr = "Log\(categoryExpr)"
    } else {
      loggerExpr = "Log.default"
    }

    return """
    ({
      let level = LogLevel.fault
      guard LogProcess.shared.canLogging(level: level) else {
        return
      }

      let newMessage = LogProcess.shared.replaceMessage(from: "\(raw: combinedMessage)", level: level)
      \(loggerExpr)
        .fault("\\(LogMessage.make(newMessage, file: #file, function: #function, line: #line))")

      LogProcess.shared.executePostAction(rawMessages: \(messagesArraySyntax), postedMessage: newMessage, level: level, file: #file, function: #function, line: #line)
    })()
    """
  }
}
