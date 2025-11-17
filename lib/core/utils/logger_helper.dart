import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// Enhanced logger helper with static methods for backward compatibility
class LoggerHelper {
  static final Map<String, LoggerHelper> _instances = {};
  static const String _defaultTag = 'APP';
  // Default logger for static methods
  static final LoggerHelper _defaultLogger = LoggerHelper._(
    _defaultTag,
    level: Level.debug,
  );
  final Logger _logger;
  final String tag; // Context or module identifier
  // Private constructor for singleton-like behavior per tag
  LoggerHelper._(this.tag, {Level level = Level.debug, bool useJson = false})
    : _logger = Logger(
        printer: useJson
            ? SimplePrinter() // JSON-friendly output
            : _FdxPrettyPrinter(tag: tag), // Custom pretty printer
        level: level,
        output: _MultiOutput([
          ConsoleOutput(),
          _FileOutput(), // Logs to file in app's document directory
        ]),
      );
  // Factory to get or create a logger instance with a specific tag
  factory LoggerHelper({
    String tag = _defaultTag,
    Level level = Level.debug,
    bool useJson = false,
  }) {
    return _instances.putIfAbsent(
      tag,
      () => LoggerHelper._(tag, level: level, useJson: useJson),
    );
  }
  // Static debug log (backward compatible)
  static void debug(String message) {
    _defaultLogger._logDebug(message);
  }
  // Static info log (backward compatible)
  static void info(String message) {
    _defaultLogger._logInfo(message);
  }
  // Static warning log (backward compatible)
  static void warning(String message) {
    _defaultLogger._logWarning(message);
  }
  // Static error log (backward compatible)
  static void error(String message, [dynamic error]) {
    _defaultLogger._logError(message, error: error);
  }
  // Instance debug log with optional context
  void _logDebug(String message, {Map<String, dynamic>? context}) {
    _logger.d(_formatMessage(message, context));
  }
  // Instance info log with optional context
  void _logInfo(String message, {Map<String, dynamic>? context}) {
    _logger.i(_formatMessage(message, context));
  }
  // Instance warning log with optional context
  void _logWarning(String message, {Map<String, dynamic>? context}) {
    _logger.w(_formatMessage(message, context));
  }
  // Instance error log with optional error, stack trace, and context
  void _logError(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    _logger.e(
      _formatMessage(message, context),
      error: error,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }
  // Formats message with context and caller info
  String _formatMessage(String message, Map<String, dynamic>? context) {
    final callerInfo = _getCallerInfo();
    final contextStr = context != null
        ? ' | Context: ${context.toString()}'
        : '';
    return '$callerInfo | $message$contextStr';
  }
  // Extracts caller info (file and line number) from stack trace
  String _getCallerInfo() {
    final trace = StackTrace.current.toString().split('\n');
    // Skip internal logger calls (usually 2-3 frames up the stack)
    for (var i = 2; i < trace.length; i++) {
      final frame = trace[i].trim();
      if (frame.isNotEmpty &&
          !frame.contains('FdxLoggerHelper') &&
          !frame.contains('Logger')) {
        final match = RegExp(r'(\w+\.\w+):(\d+):(\d+)').firstMatch(frame);
        if (match != null) {
          return '${match.group(1)}:${match.group(2)}';
        }
        break;
      }
    }
    return 'unknown';
  }
}
// Custom pretty printer with tag, timestamp, and enhanced formatting
class _FdxPrettyPrinter extends PrettyPrinter {
  final String tag;
  _FdxPrettyPrinter({required this.tag})
    : super(
        methodCount: 0, // Reduce stack trace noise
        errorMethodCount: 3, // Show fewer lines for errors
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTime,
      );
  @override
  List<String> log(LogEvent event) {
    final time = DateTime.now()
        .toString()
        .split(' ')[1]
        .substring(0, 8); // HH:mm:ss
    final level = event.level;
    final message = event.message.toString();
    final emoji = _getEmoji(level);
    final levelStr = _getLevelString(level).padRight(7); // Align levels
    // Format main log line
    final logLine = '$emoji [$time] [$tag] $levelStr $message';
    // Handle error and stack trace
    final lines = <String>[logLine];
    if (event.error != null) {
      lines.add('└── Error: ${event.error}');
    }
    if (event.stackTrace != null && level == Level.error) {
      final stackLines = event.stackTrace
          .toString()
          .split('\n')
          .take(3)
          .map((line) => '    $line');
      lines.addAll(stackLines);
    }
    return lines;
  }
  // Get emoji for log level
  String _getEmoji(Level level) {
    switch (level) {
      case Level.debug:
        return ':bug:';
      case Level.info:
        return ':information_source:';
      case Level.warning:
        return ':warning:';
      case Level.error:
        return ':x:';
      default:
        return '';
    }
  }
  // Get level string
  String _getLevelString(Level level) {
    return level.toString().split('.').last.toUpperCase();
  }
}
// File output for persistent logging
class _FileOutput extends LogOutput {
  File? _logFile;
  _FileOutput() {
    _initFile();
  }
  Future<void> _initFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/app_logs.txt';
      _logFile = File(path);
      // Ensure file exists
      if (!await _logFile!.exists()) {
        await _logFile!.create(recursive: true);
      }
    } catch (e) {
      // Fallback to console if file init fails
      debugPrint('Failed to initialize log file: $e');
    }
  }
  @override
  void output(OutputEvent event) {
    if (_logFile == null) return;
    final lines = event.lines.map((line) => '$line\n').join();
    _logFile!.writeAsString(lines, mode: FileMode.append);
  }
}
// Multi-output support for console, file, etc.
class _MultiOutput extends LogOutput {
  final List<LogOutput> outputs;
  _MultiOutput(this.outputs);
  @override
  void output(OutputEvent event) {
    for (var output in outputs) {
      output.output(event);
    }
  }
}