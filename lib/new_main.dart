import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoApp(),
    );
  }
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  List<dynamic> data = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    controller.text = "Hello world";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Task"),
        ),
        floatingActionButton: data.isEmpty
            ? Container(
                width: 120,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.add), Text("Add Note")],
                ),
              )
            : Container(),
        body:
            Container() /*Center(
        child: SizedBox(
          width: 220,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  color: Colors.blue[100]!,
                  padding: const EdgeInsets.all(15),
                  child: ListenableBuilder(
                    listenable: controller,
                    builder: (ctx, widget) => TimeStampedChatMessage(text: controller.text, sentAt: '2 Minutes ago', style: const TextStyle(color: Colors.red)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: TextField(controller: controller),
              )
            ],
          ),
        ),
      ),*/
        );
  }
}

class TimeStampedChatMessage extends LeafRenderObjectWidget {
  const TimeStampedChatMessage({super.key, required this.text, required this.sentAt, required this.style});

  final String text, sentAt;
  final TextStyle style;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimeStampedChatMessageRenderObject(text: text, sentAt: sentAt, style: style, textDirection: Directionality.of(context));
  }

  @override
  void updateRenderObject(BuildContext context, TimeStampedChatMessageRenderObject renderObject) {
    renderObject.text = text;
    renderObject.sentAt = sentAt;
    renderObject.style = style;
    renderObject.textDirection = Directionality.of(context);
  }
}

class TimeStampedChatMessageRenderObject extends RenderBox {
  late String _sentAt, _text;
  late TextStyle _style;
  late TextDirection _textDirection;
  late TextPainter _textPainter;
  late TextPainter _sentAtTextPainter;

  /// Saved values from  'perform Layout' used in paint.
  late bool _sentAtFitOnLastLine;
  late double _lineHeight;
  late double _lastMessageLineWidth;
  late double _longestLineWidth;
  late double _sentAtLineWidth;
  late int _numMessageLines;

  TimeStampedChatMessageRenderObject({required String sentAt, required String text, required TextStyle style, required TextDirection textDirection}) {
    _sentAt = sentAt;
    _text = text;
    _style = style;
    _textDirection = textDirection;
    _textPainter = TextPainter(text: textSpan, textDirection: _textDirection);
    _sentAtTextPainter = TextPainter(text: sentAtTextSpan, textDirection: _textDirection);
  }

  String get text => _text;

  String get sentAt => _sentAt;

  TextStyle get style => _style;

  set style(TextStyle val) {
    if (val == _text) {
      // This is the guard statement.
      return;
    }
    _style = val;
    _sentAtTextPainter.text = sentAtTextSpan;
    _textPainter.text = textSpan;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  set sentAt(String val) {
    if (val == _text) {
      // This is the guard statement.
      return;
    }
    _sentAt = val;
    _sentAtTextPainter.text = sentAtTextSpan;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection val) {
    if (_textDirection == val) {
      return;
    }
    _textDirection = val;
    _textPainter.textDirection = val;
    _sentAtTextPainter.textDirection = val;
  }

  TextSpan get textSpan => TextSpan(text: _text, style: _style);

  TextSpan get sentAtTextSpan => TextSpan(text: _sentAt, style: _style.copyWith(color: Colors.grey));

  set text(String val) {
    if (val == _text) {
      // This is the guard statement.
      return;
    }
    _text = val;
    _textPainter.text = textSpan;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
  }

  @override
  void performLayout() {
    _textPainter.layout(maxWidth: constraints.maxWidth);
    final textLines = _textPainter.computeLineMetrics();
    _longestLineWidth = 0;
    for (final line in textLines) {
      _longestLineWidth = max(_longestLineWidth, line.width);
    }
    _lastMessageLineWidth = textLines.last.width;
    _lineHeight = textLines.last.height;
    _numMessageLines = textLines.length;

    _sentAtTextPainter.layout(maxWidth: constraints.maxWidth);
    _sentAtLineWidth = _sentAtTextPainter.computeLineMetrics().first.width;

    final sizeOfMessage = Size(_longestLineWidth, _textPainter.height);

    final lastLineWithDate = _lastMessageLineWidth + (_sentAtLineWidth * 1.1);
    if (textLines.length == 1) {
      _sentAtFitOnLastLine = lastLineWithDate < constraints.maxWidth;
    } else {
      _sentAtFitOnLastLine = lastLineWithDate < min(_longestLineWidth, constraints.maxWidth);
    }

    late Size computedSize;
    if (!_sentAtFitOnLastLine) {
      computedSize = Size(sizeOfMessage.width, sizeOfMessage.height + _sentAtTextPainter.height);
    } else {
      if (textLines.length == 1) {
        computedSize = Size(lastLineWithDate, sizeOfMessage.height);
      } else {
        computedSize = Size(_longestLineWidth, sizeOfMessage.height);
      }
    }
    size = constraints.constrain(computedSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _textPainter.paint(context.canvas, offset);
    late Offset sentAtOffset;
    if (_sentAtFitOnLastLine) {
      sentAtOffset = Offset(offset.dx + (size.width - _sentAtLineWidth), offset.dy + (_lineHeight * (_numMessageLines - 1)));
    } else {
      sentAtOffset = Offset(offset.dx + (size.width - _sentAtLineWidth), offset.dy + (_lineHeight * _numMessageLines));
    }

    _sentAtTextPainter.paint(context.canvas, sentAtOffset);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
    config.label = '$_text, sent at $_sentAt';
    config.textDirection = _textDirection;
  }
}
