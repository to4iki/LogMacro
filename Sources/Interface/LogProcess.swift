public protocol LogReplacingPlugin {
  func newMessage(from message: String, level: LogLevel) -> String
}

public protocol LogPostActionPlugin {
  func execute(message: Any, level: LogLevel, file: String, function: String, line: Int)
}

public final class LogProcess {
  private var enabledLogLevel: LogLevel = .debug
  private var replacingPlugin: LogReplacingPlugin?
  private var postActionPlugins: [LogPostActionPlugin] = []

  public nonisolated(unsafe) static let shared = LogProcess()
  private init() {}

  public func setEnabledLogLevel(_ level: LogLevel) {
    self.enabledLogLevel = level
  }

  public func setReplacingPlugin(_ plugin: LogReplacingPlugin) {
    self.replacingPlugin = plugin
  }

  public func setPostActionPlugins(_ plugins: LogPostActionPlugin...) {
    self.postActionPlugins = plugins
  }

  public func canLogging(level: LogLevel) -> Bool {
    level >= enabledLogLevel
  }

  public func replaceMessage(from message: String, level: LogLevel) -> String {
    guard let replacingPlugin else {
      return message
    }
    return replacingPlugin.newMessage(from: message, level: level)
  }

  public func executePostAction(message: Any, level: LogLevel, file: String, function: String, line: Int) {
    for plugin in postActionPlugins {
      plugin.execute(message: message, level: level, file: file, function: function, line: line)
    }
  }
}
