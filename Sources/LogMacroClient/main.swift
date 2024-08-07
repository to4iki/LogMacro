import LogMacro

struct PasswordLogReplacingPlugin: LogReplacingPlugin {
  func newMessage(from message: String, level: LogLevel) -> String {
    message.replacingOccurrences(of: "password", with: "")
  }
}

struct MyErrorLogPostActionPlugin: LogPostActionPlugin {
  func execute(rawMessages: [Any], postedMessage: String, level: LogLevel, file: String, function: String, line: Int) {
    guard level >= .fault else {
      return
    }
    guard rawMessages.contains(where: { $0 is MyError }) else {
      return
    }
    print("MyErrorLogPostActionPlugin")
  }
}

enum MyError: Error {
  case unknown
}

func func1() {
  #logDebug("debug1", "debug2")
}

func func2() {
  #logWarn("warn", category: .tracking)
}

func func3() {
  #logFault(MyError.unknown, category: .network)
}

// MARK: - execute

LogProcess.shared.setReplacingPlugin(PasswordLogReplacingPlugin())
LogProcess.shared.setPostActionPlugins(MyErrorLogPostActionPlugin())

func1()
func2()
_ = try await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
func3()
_ = try await Task.sleep(nanoseconds: UInt64(1 * 1_000_000_000))
