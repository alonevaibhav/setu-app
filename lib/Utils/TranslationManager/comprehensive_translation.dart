// // translatable_form_fields.dart
// import 'package:flutter/material.dart';
// import 'package:setuapp/Utils/TranslationManager/text_translation_service.dart';
// import 'package:setuapp/Utils/TranslationManager/translation_service.dart';
//
// /// A TextFormField with translation support for labels and hints
// class TranslatableTextFormField extends StatefulWidget {
//   final String? labelText;
//   final String? hintText;
//   final String? helperText;
//   final String? errorText;
//   final TextEditingController? controller;
//   final String? Function(String?)? validator;
//   final void Function(String?)? onSaved;
//   final void Function(String)? onChanged;
//   final void Function()? onTap;
//   final bool readOnly;
//   final bool obscureText;
//   final TextInputType? keyboardType;
//   final TextInputAction? textInputAction;
//   final int? maxLines;
//   final int? minLines;
//   final int? maxLength;
//   final bool enabled;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final EdgeInsets? contentPadding;
//   final InputBorder? border;
//   final InputBorder? focusedBorder;
//   final InputBorder? enabledBorder;
//   final InputBorder? errorBorder;
//   final Color? fillColor;
//   final bool filled;
//   final TextStyle? style;
//   final TextStyle? labelStyle;
//   final TextStyle? hintStyle;
//   final TextStyle? helperStyle;
//   final TextStyle? errorStyle;
//   final FloatingLabelBehavior? floatingLabelBehavior;
//   final bool isDense;
//   final String? semanticCounterText;
//   final bool? showCursor;
//   final String? restorationId;
//   final bool enableSuggestions;
//   final bool autocorrect;
//   final bool enableInteractiveSelection;
//   final Widget? counter;
//   final String? counterText;
//   final FocusNode? focusNode;
//   final bool autofocus;
//   final TextAlign textAlign;
//   final TextDirection? textDirection;
//   final Locale? locale;
//   final bool expands;
//   final TextAlignVertical? textAlignVertical;
//   final bool? enableIMEPersonalizedLearning;
//
//   // Translation specific
//   final bool enableTranslation;
//   final String? targetLanguage;
//   final String sourceLanguage;
//
//   const TranslatableTextFormField({
//     Key? key,
//     this.labelText,
//     this.hintText,
//     this.helperText,
//     this.errorText,
//     this.controller,
//     this.validator,
//     this.onSaved,
//     this.onChanged,
//     this.onTap,
//     this.readOnly = false,
//     this.obscureText = false,
//     this.keyboardType,
//     this.textInputAction,
//     this.maxLines = 1,
//     this.minLines,
//     this.maxLength,
//     this.enabled = true,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.contentPadding,
//     this.border,
//     this.focusedBorder,
//     this.enabledBorder,
//     this.errorBorder,
//     this.fillColor,
//     this.filled = false,
//     this.style,
//     this.labelStyle,
//     this.hintStyle,
//     this.helperStyle,
//     this.errorStyle,
//     this.floatingLabelBehavior,
//     this.isDense = false,
//     this.semanticCounterText,
//     this.showCursor,
//     this.restorationId,
//     this.enableSuggestions = true,
//     this.autocorrect = true,
//     this.enableInteractiveSelection = true,
//     this.counter,
//     this.counterText,
//     this.focusNode,
//     this.autofocus = false,
//     this.textAlign = TextAlign.start,
//     this.textDirection,
//     this.locale,
//     this.expands = false,
//     this.textAlignVertical,
//     this.enableIMEPersonalizedLearning,
//     this.enableTranslation = true,
//     this.targetLanguage,
//     this.sourceLanguage = 'auto',
//     required InputDecoration decoration,
//   }) : super(key: key);
//
//   @override
//   State<TranslatableTextFormField> createState() => _TranslatableTextFormFieldState();
// }
//
// class _TranslatableTextFormFieldState extends State<TranslatableTextFormField> {
//   String? _translatedLabelText;
//   String? _translatedHintText;
//   String? _translatedHelperText;
//   String? _translatedErrorText;
//   bool _isTranslating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeTranslations();
//   }
//
//   @override
//   void didUpdateWidget(TranslatableTextFormField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     if (oldWidget.labelText != widget.labelText ||
//         oldWidget.hintText != widget.hintText ||
//         oldWidget.helperText != widget.helperText ||
//         oldWidget.errorText != widget.errorText ||
//         oldWidget.targetLanguage != widget.targetLanguage ||
//         oldWidget.enableTranslation != widget.enableTranslation) {
//       _initializeTranslations();
//     }
//   }
//
//   void _initializeTranslations() {
//     _translatedLabelText = widget.labelText;
//     _translatedHintText = widget.hintText;
//     _translatedHelperText = widget.helperText;
//     _translatedErrorText = widget.errorText;
//
//     if (widget.enableTranslation) {
//       _translateTexts();
//     }
//   }
//
//   Future<void> _translateTexts() async {
//     if (!widget.enableTranslation) return;
//
//     final targetLang = widget.targetLanguage ??
//         TranslationManager.instance.currentLanguage?.code;
//
//     if (targetLang == null || targetLang == 'en') {
//       setState(() {
//         _translatedLabelText = widget.labelText;
//         _translatedHintText = widget.hintText;
//         _translatedHelperText = widget.helperText;
//         _translatedErrorText = widget.errorText;
//       });
//       return;
//     }
//
//     setState(() {
//       _isTranslating = true;
//     });
//
//     try {
//       final textsToTranslate = <String, String>{};
//
//       if (widget.labelText != null && widget.labelText!.isNotEmpty) {
//         textsToTranslate['label'] = widget.labelText!;
//       }
//       if (widget.hintText != null && widget.hintText!.isNotEmpty) {
//         textsToTranslate['hint'] = widget.hintText!;
//       }
//       if (widget.helperText != null && widget.helperText!.isNotEmpty) {
//         textsToTranslate['helper'] = widget.helperText!;
//       }
//       if (widget.errorText != null && widget.errorText!.isNotEmpty) {
//         textsToTranslate['error'] = widget.errorText!;
//       }
//
//       if (textsToTranslate.isNotEmpty) {
//         final results = await TranslationService.instance.translateBatch(
//           texts: textsToTranslate.values.toList(),
//           targetLanguage: targetLang,
//           sourceLanguage: widget.sourceLanguage,
//         );
//
//         if (mounted) {
//           setState(() {
//             if (textsToTranslate.containsKey('label')) {
//               _translatedLabelText = results[textsToTranslate['label']]?.text ?? widget.labelText;
//             }
//             if (textsToTranslate.containsKey('hint')) {
//               _translatedHintText = results[textsToTranslate['hint']]?.text ?? widget.hintText;
//             }
//             if (textsToTranslate.containsKey('helper')) {
//               _translatedHelperText = results[textsToTranslate['helper']]?.text ?? widget.helperText;
//             }
//             if (textsToTranslate.containsKey('error')) {
//               _translatedErrorText = results[textsToTranslate['error']]?.text ?? widget.errorText;
//             }
//             _isTranslating = false;
//           });
//         }
//       } else {
//         setState(() {
//           _isTranslating = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _translatedLabelText = widget.labelText;
//           _translatedHintText = widget.hintText;
//           _translatedHelperText = widget.helperText;
//           _translatedErrorText = widget.errorText;
//           _isTranslating = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       key: widget.key,
//       controller: widget.controller,
//       validator: widget.validator,
//       onSaved: widget.onSaved,
//       onChanged: widget.onChanged,
//       onTap: widget.onTap,
//       readOnly: widget.readOnly,
//       obscureText: widget.obscureText,
//       keyboardType: widget.keyboardType,
//       textInputAction: widget.textInputAction,
//       maxLines: widget.maxLines,
//       minLines: widget.minLines,
//       maxLength: widget.maxLength,
//       enabled: widget.enabled,
//       focusNode: widget.focusNode,
//       autofocus: widget.autofocus,
//       textAlign: widget.textAlign,
//       textDirection: widget.textDirection,
//       expands: widget.expands,
//       textAlignVertical: widget.textAlignVertical,
//       enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning ?? true,
//       showCursor: widget.showCursor,
//       restorationId: widget.restorationId,
//       enableSuggestions: widget.enableSuggestions,
//       autocorrect: widget.autocorrect,
//       enableInteractiveSelection: widget.enableInteractiveSelection,
//       style: widget.style,
//       decoration: InputDecoration(
//         labelText: _translatedLabelText,
//         hintText: _translatedHintText,
//         helperText: _translatedHelperText,
//         errorText: _translatedErrorText,
//         prefixIcon: widget.prefixIcon,
//         suffixIcon: _isTranslating
//             ? SizedBox(
//           width: 16,
//           height: 16,
//           child: Padding(
//             padding: EdgeInsets.all(12),
//             child: CircularProgressIndicator(strokeWidth: 2),
//           ),
//         )
//             : widget.suffixIcon,
//         contentPadding: widget.contentPadding,
//         border: widget.border,
//         focusedBorder: widget.focusedBorder,
//         enabledBorder: widget.enabledBorder,
//         errorBorder: widget.errorBorder,
//         fillColor: widget.fillColor,
//         filled: widget.filled,
//         labelStyle: widget.labelStyle,
//         hintStyle: widget.hintStyle,
//         helperStyle: widget.helperStyle,
//         errorStyle: widget.errorStyle,
//         floatingLabelBehavior: widget.floatingLabelBehavior,
//         isDense: widget.isDense,
//         semanticCounterText: widget.semanticCounterText,
//         counter: widget.counter,
//         counterText: widget.counterText,
//       ),
//     );
//   }
// }
//
// /// Translatable DropdownButtonFormField
// class TranslatableDropdownButtonFormField<T> extends StatefulWidget {
//   final String? labelText;
//   final String? hintText;
//   final String? helperText;
//   final T? value;
//   final List<DropdownMenuItem<T>>? items;
//   final void Function(T?)? onChanged;
//   final String? Function(T?)? validator;
//   final void Function(T?)? onSaved;
//   final InputDecoration? decoration;
//   final bool isDense;
//   final bool isExpanded;
//   final Widget? icon;
//   final Color? iconDisabledColor;
//   final Color? iconEnabledColor;
//   final double iconSize;
//   final bool autofocus;
//   final Color? dropdownColor;
//   final FocusNode? focusNode;
//   final bool enableFeedback;
//   final AlignmentGeometry alignment;
//   final BorderRadius? borderRadius;
//
//   // Translation specific
//   final bool enableTranslation;
//   final String? targetLanguage;
//   final String sourceLanguage;
//
//   const TranslatableDropdownButtonFormField({
//     Key? key,
//     this.labelText,
//     this.hintText,
//     this.helperText,
//     this.value,
//     this.items,
//     this.onChanged,
//     this.validator,
//     this.onSaved,
//     this.decoration,
//     this.isDense = false,
//     this.isExpanded = false,
//     this.icon,
//     this.iconDisabledColor,
//     this.iconEnabledColor,
//     this.iconSize = 24.0,
//     this.autofocus = false,
//     this.dropdownColor,
//     this.focusNode,
//     this.enableFeedback = true,
//     this.alignment = AlignmentDirectional.centerStart,
//     this.borderRadius,
//     this.enableTranslation = true,
//     this.targetLanguage,
//     this.sourceLanguage = 'auto',
//   }) : super(key: key);
//
//   @override
//   State<TranslatableDropdownButtonFormField<T>> createState() =>
//       _TranslatableDropdownButtonFormFieldState<T>();
// }
//
// class _TranslatableDropdownButtonFormFieldState<T>
//     extends State<TranslatableDropdownButtonFormField<T>> {
//   String? _translatedLabelText;
//   String? _translatedHintText;
//   String? _translatedHelperText;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeTranslations();
//   }
//
//   @override
//   void didUpdateWidget(TranslatableDropdownButtonFormField<T> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     if (oldWidget.labelText != widget.labelText ||
//         oldWidget.hintText != widget.hintText ||
//         oldWidget.helperText != widget.helperText ||
//         oldWidget.targetLanguage != widget.targetLanguage ||
//         oldWidget.enableTranslation != widget.enableTranslation) {
//       _initializeTranslations();
//     }
//   }
//
//   void _initializeTranslations() {
//     _translatedLabelText = widget.labelText;
//     _translatedHintText = widget.hintText;
//     _translatedHelperText = widget.helperText;
//
//     if (widget.enableTranslation) {
//       _translateTexts();
//     }
//   }
//
//   Future<void> _translateTexts() async {
//     if (!widget.enableTranslation) return;
//
//     final targetLang = widget.targetLanguage ??
//         TranslationManager.instance.currentLanguage?.code;
//
//     if (targetLang == null || targetLang == 'en') {
//       setState(() {
//         _translatedLabelText = widget.labelText;
//         _translatedHintText = widget.hintText;
//         _translatedHelperText = widget.helperText;
//       });
//       return;
//     }
//
//     try {
//       final textsToTranslate = <String, String>{};
//
//       if (widget.labelText != null && widget.labelText!.isNotEmpty) {
//         textsToTranslate['label'] = widget.labelText!;
//       }
//       if (widget.hintText != null && widget.hintText!.isNotEmpty) {
//         textsToTranslate['hint'] = widget.hintText!;
//       }
//       if (widget.helperText != null && widget.helperText!.isNotEmpty) {
//         textsToTranslate['helper'] = widget.helperText!;
//       }
//
//       if (textsToTranslate.isNotEmpty) {
//         final results = await TranslationService.instance.translateBatch(
//           texts: textsToTranslate.values.toList(),
//           targetLanguage: targetLang,
//           sourceLanguage: widget.sourceLanguage,
//         );
//
//         if (mounted) {
//           setState(() {
//             if (textsToTranslate.containsKey('label')) {
//               _translatedLabelText = results[textsToTranslate['label']]?.text ?? widget.labelText;
//             }
//             if (textsToTranslate.containsKey('hint')) {
//               _translatedHintText = results[textsToTranslate['hint']]?.text ?? widget.hintText;
//             }
//             if (textsToTranslate.containsKey('helper')) {
//               _translatedHelperText = results[textsToTranslate['helper']]?.text ?? widget.helperText;
//             }
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _translatedLabelText = widget.labelText;
//           _translatedHintText = widget.hintText;
//           _translatedHelperText = widget.helperText;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<T>(
//       key: widget.key,
//       value: widget.value,
//       items: widget.items,
//       onChanged: widget.onChanged,
//       validator: widget.validator,
//       onSaved: widget.onSaved,
//       isDense: widget.isDense,
//       isExpanded: widget.isExpanded,
//       icon: widget.icon,
//       iconDisabledColor: widget.iconDisabledColor,
//       iconEnabledColor: widget.iconEnabledColor,
//       iconSize: widget.iconSize,
//       autofocus: widget.autofocus,
//       dropdownColor: widget.dropdownColor,
//       focusNode: widget.focusNode,
//       enableFeedback: widget.enableFeedback,
//       alignment: widget.alignment,
//       borderRadius: widget.borderRadius,
//       decoration: widget.decoration?.copyWith(
//         labelText: _translatedLabelText,
//         hintText: _translatedHintText,
//         helperText: _translatedHelperText,
//       ) ?? InputDecoration(
//         labelText: _translatedLabelText,
//         hintText: _translatedHintText,
//         helperText: _translatedHelperText,
//       ),
//     );
//   }
// }
//
// /// Helper for creating translatable dropdown menu items
// class TranslatableDropdownMenuItem<T> extends StatelessWidget {
//   final T value;
//   final String text;
//   final bool enableTranslation;
//   final String? targetLanguage;
//   final String sourceLanguage;
//   final VoidCallback? onTap;
//   final AlignmentGeometry alignment;
//   final TextStyle? style;
//
//   const TranslatableDropdownMenuItem({
//     Key? key,
//     required this.value,
//     required this.text,
//     this.enableTranslation = true,
//     this.targetLanguage,
//     this.sourceLanguage = 'auto',
//     this.onTap,
//     this.alignment = AlignmentDirectional.centerStart,
//     this.style,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenuItem<T>(
//       value: value,
//       onTap: onTap,
//       alignment: alignment,
//       child: TranslatableText(
//         text,
//         style: style,
//         enableTranslation: enableTranslation,
//         targetLanguage: targetLanguage,
//         sourceLanguage: sourceLanguage,
//       ),
//     );
//   }
// }