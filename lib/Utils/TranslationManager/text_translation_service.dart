// translatable_text.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'translation_service.dart';

/// A drop-in replacement for Text widget with automatic translation
class TranslatableText extends StatefulWidget {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  // Translation specific properties
  final String? targetLanguage; // If null, uses global language
  final String sourceLanguage;
  final bool enableTranslation;
  final Widget? loadingWidget;
  final Duration debounceDelay;

  const TranslatableText(
      this.data, {
        Key? key,
        this.style,
        this.strutStyle,
        this.textAlign,
        this.textDirection,
        this.locale,
        this.softWrap,
        this.overflow,
        this.textScaleFactor,
        this.maxLines,
        this.semanticsLabel,
        this.textWidthBasis,
        this.textHeightBehavior,
        this.selectionColor,
        this.targetLanguage,
        this.sourceLanguage = 'auto',
        this.enableTranslation = true,
        this.loadingWidget,
        this.debounceDelay = const Duration(milliseconds: 300),
      }) : super(key: key);

  @override
  State<TranslatableText> createState() => _TranslatableTextState();
}

class _TranslatableTextState extends State<TranslatableText> {
  String _displayText = '';
  bool _isLoading = false;
  bool _hasError = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _displayText = widget.data;
    _translateText();
  }

  @override
  void didUpdateWidget(TranslatableText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data ||
        oldWidget.targetLanguage != widget.targetLanguage ||
        oldWidget.enableTranslation != widget.enableTranslation) {
      _displayText = widget.data;
      _translateText();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _translateText() {
    if (!widget.enableTranslation || widget.data.trim().isEmpty) {
      setState(() {
        _displayText = widget.data;
        _isLoading = false;
        _hasError = false;
      });
      return;
    }

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Debounce translation requests
    _debounceTimer = Timer(widget.debounceDelay, () async {
      final targetLang = widget.targetLanguage ??
          TranslationManager.instance.currentLanguage?.code;

      if (targetLang == null || targetLang == 'en') {
        setState(() {
          _displayText = widget.data;
          _isLoading = false;
          _hasError = false;
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      try {
        final result = await TranslationService.instance.translate(
          text: widget.data,
          targetLanguage: targetLang,
          sourceLanguage: widget.sourceLanguage,
        );

        if (mounted) {
          setState(() {
            _displayText = result.text;
            _isLoading = false;
            _hasError = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _displayText = widget.data; // Fallback to original text
            _isLoading = false;
            _hasError = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    return Text(
      _displayText,
      key: widget.key,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaleFactor: widget.textScaleFactor,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      selectionColor: widget.selectionColor,
    );
  }
}

/// Rich text version with translation support
class TranslatableRichText extends StatefulWidget {
  final InlineSpan text;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  // Translation properties
  final String? targetLanguage;
  final String sourceLanguage;
  final bool enableTranslation;

  const TranslatableRichText({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.selectionColor,
    this.targetLanguage,
    this.sourceLanguage = 'auto',
    this.enableTranslation = true,
  }) : super(key: key);

  @override
  State<TranslatableRichText> createState() => _TranslatableRichTextState();
}

class _TranslatableRichTextState extends State<TranslatableRichText> {
  InlineSpan _displayText;
  bool _isLoading = false;

  _TranslatableRichTextState() : _displayText = const TextSpan();

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;
    _translateRichText();
  }

  @override
  void didUpdateWidget(TranslatableRichText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text ||
        oldWidget.targetLanguage != widget.targetLanguage ||
        oldWidget.enableTranslation != widget.enableTranslation) {
      _displayText = widget.text;
      _translateRichText();
    }
  }

  void _translateRichText() async {
    if (!widget.enableTranslation) {
      setState(() {
        _displayText = widget.text;
        _isLoading = false;
      });
      return;
    }

    final targetLang = widget.targetLanguage ??
        TranslationManager.instance.currentLanguage?.code;

    if (targetLang == null || targetLang == 'en') {
      setState(() {
        _displayText = widget.text;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final translatedSpan = await _translateInlineSpan(widget.text, targetLang);

      if (mounted) {
        setState(() {
          _displayText = translatedSpan;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _displayText = widget.text;
          _isLoading = false;
        });
      }
    }
  }

  Future<InlineSpan> _translateInlineSpan(InlineSpan span, String targetLang) async {
    if (span is TextSpan) {
      String? translatedText;

      if (span.text != null && span.text!.trim().isNotEmpty) {
        final result = await TranslationService.instance.translate(
          text: span.text!,
          targetLanguage: targetLang,
          sourceLanguage: widget.sourceLanguage,
        );
        translatedText = result.text;
      }

      List<InlineSpan>? translatedChildren;
      if (span.children != null) {
        translatedChildren = [];
        for (final child in span.children!) {
          final translatedChild = await _translateInlineSpan(child, targetLang);
          translatedChildren.add(translatedChild);
        }
      }

      return TextSpan(
        text: translatedText,
        style: span.style,
        children: translatedChildren,
        recognizer: span.recognizer,
        mouseCursor: span.mouseCursor,
        onEnter: span.onEnter,
        onExit: span.onExit,
        semanticsLabel: span.semanticsLabel,
        locale: span.locale,
        spellOut: span.spellOut,
      );
    }

    return span; // Return as-is for other span types
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      key: widget.key,
      text: _displayText,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaler: TextScaler.linear(widget.textScaleFactor),
      maxLines: widget.maxLines,
      locale: widget.locale,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      selectionColor: widget.selectionColor,
    );
  }
}

/// Translation Manager for global language state
class TranslationManager extends ChangeNotifier {
  static TranslationManager? _instance;
  static TranslationManager get instance => _instance ??= TranslationManager._internal();

  TranslationManager._internal();

  Language? _currentLanguage;
  Language? get currentLanguage => _currentLanguage;

  /// Set the global language for all TranslatableText widgets
  void setLanguage(Language? language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  /// Initialize with default language
  void initialize({Language? defaultLanguage}) {
    _currentLanguage = defaultLanguage;
  }
}

/// Extension to make migration easier
extension TextExtension on Text {
  TranslatableText translatable({
    String? targetLanguage,
    String sourceLanguage = 'auto',
    bool enableTranslation = true,
    Widget? loadingWidget,
    Duration debounceDelay = const Duration(milliseconds: 300),
  }) {
    return TranslatableText(
      data!,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      targetLanguage: targetLanguage,
      sourceLanguage: sourceLanguage,
      enableTranslation: enableTranslation,
      loadingWidget: loadingWidget,
      debounceDelay: debounceDelay,
    );
  }
}


