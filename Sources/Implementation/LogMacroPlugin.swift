import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct LogMacroPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    LogDebugMacro.self,
    LogWarnMacro.self,
    LogFaultMacro.self
  ]
}
