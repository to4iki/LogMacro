# LogMacro
![Swift 5](https://img.shields.io/badge/swift-5-orange.svg)
![SPM compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)
![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)

A macro that outputs logs with formatting anywhere across modules.

## Installation
### Swift Package Manager
```swift
.package(url: "https://github.com/to4iki/LogMacro", from: <#version#>)
```

## Usage
#### debug
```swift
#logDebug("debug")
```

#### warn
```swift
#logWarn("warn", category: .tracking)
```

#### fault
```swift
enum MyError: Error {
  case unknown
}

#logFault(MyError.unknown, category: .network)
```

#### Restrict logs to be posted per level
Set global `LogLevel` and configure which logs can be sent on a per-application basis.

```swift
LogProcess.shared.setEnabledLogLevel(.warn)
```

#### Replacing log message
Register a `LogReplacingPlugin` for rewrite outgoing log messages.

```swift
/// Replace the string "password" with an empty string.
struct PasswordLogReplacingPlugin: LogReplacingPlugin {
  func newMessage(from message: String, level: LogLevel) -> String {
    message.replacingOccurrences(of: "password", with: "")
  }
}

LogProcess.shared.setReplacingPlugin(PasswordLogReplacingPlugin())
```

#### Processing after log post
Register a `LogPostActionPlugin` for perform any processing after the log is post.

```swift
/// Print output only when message is `MyError`.
struct MyErrorLogPostActionPlugin: LogPostActionPlugin {
  func execute(message: Any, level: LogLevel, file: String, function: String, line: Int) {
    guard level >= .fault else {
      return
    }
    guard message is MyError else {
      return
    }
    print("MyErrorLogPostActionPlugin")
  }
}

LogProcess.shared.setPostActionPlugins(MyErrorLogPostActionPlugin())
```

## License
LogMacro is released under the MIT license.
