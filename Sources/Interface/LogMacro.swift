/// A macro that outputs `Logger.debug` with formatting anywhere across modules.
@freestanding(expression)
public macro logDebug(
  _ message: Any,
  category: LogCategory = .default
) = #externalMacro(module: "LogMacroImplementation", type: "LogDebugMacro")

/// A macro that outputs `Logger.warning` with formatting anywhere across modules.
@freestanding(expression)
public macro logWarn(
  _ message: Any,
  category: LogCategory = .default
) = #externalMacro(module: "LogMacroImplementation", type: "LogWarnMacro")

/// A macro that outputs `Logger.fault` with formatting anywhere across modules.
@freestanding(expression)
public macro logFault(
  _ message: Any,
  category: LogCategory = .default
) = #externalMacro(module: "LogMacroImplementation", type: "LogFaultMacro")
