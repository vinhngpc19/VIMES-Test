import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputText extends StatefulWidget {
  const CustomInputText({
    super.key,
    this.iconLeading,
    this.widgetLeading,
    required this.hintText,
    required this.controller,
    this.currentNode,
    this.title = '',
    this.submitFunc,
    this.obscureText = false,
    this.iconNextTextInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.textInputType = TextInputType.text,
    this.inputFormatters,
    this.isReadOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.fontSize = 16,
    this.hintFontSize = 14,
    this.fillColor,
    this.scrollPadding,
    this.textAlign,
    this.styleText,
    this.hintStyle,
    this.validator,
    this.errText = '',
    this.height,
    this.contentPadding,
    this.borderColor,
    this.useSuffix = false,
    this.marginTop = 10,
    this.borderRadius = 0,
    this.enabledBorder = false,
    this.showRequired = true,
    this.onPress,
    this.onTap,
    this.onChanged,
  });

  final EdgeInsets? scrollPadding;
  final String title;
  final Color? fillColor;
  final double hintFontSize;
  final Color? borderColor;
  final double borderRadius;
  final String errText;
  final String? iconLeading;
  final Widget? widgetLeading;
  final String hintText;
  final TextEditingController controller;
  final FocusNode? currentNode;
  final bool obscureText;
  final bool isReadOnly;
  final Function()? submitFunc;
  final TextInputAction iconNextTextInputAction;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;

  final int maxLines;
  final int? minLines;
  final double fontSize;
  final TextStyle? styleText;
  final TextStyle? hintStyle;
  final TextAlign? textAlign;
  final double? height;
  final EdgeInsets? contentPadding;
  final String? Function(String?)? validator;
  final bool useSuffix;
  final double marginTop;
  final Function()? onPress;
  final bool enabledBorder;
  final bool showRequired;

  final VoidCallback? onTap;
  final Function(String)? onChanged;

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  bool isShowText = false;
  String? errText;
  @override
  void initState() {
    super.initState();
    isShowText = widget.obscureText;
    widget.currentNode?.addListener(() {
      if (widget.currentNode?.hasFocus == false) {
        widget.controller.text = widget.controller.text.trim();
      }
    });
  }

  @override
  void setState(Function() fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.addListener(
      () => setState(() {}),
    );
    return Padding(
      padding: EdgeInsets.only(top: widget.marginTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.showRequired)
                    const Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Icon(Icons.error, color: Colors.red, size: 12),
                    )
                ],
              ),
            )
          else
            const SizedBox(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onPress,
            child: Row(
              crossAxisAlignment: (widget.maxLines > 5)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: widget.obscureText ? 1 : (widget.maxLines),
                    minLines: widget.obscureText ? 1 : (widget.minLines),
                    autocorrect: true,
                    enableSuggestions: true,
                    scrollPadding:
                        widget.scrollPadding ?? const EdgeInsets.all(20.0),
                    textCapitalization: widget.textCapitalization,
                    inputFormatters: (widget.inputFormatters ?? []),
                    textAlign: widget.textAlign ?? TextAlign.start,
                    enabled: !widget.isReadOnly,
                    style: widget.styleText ?? const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (widget.validator != null) {
                        setState(() => errText = widget.validator!(value));
                        return widget.validator!(value);
                      } else {
                        return null;
                      }
                    },
                    textInputAction: widget.iconNextTextInputAction,
                    controller: widget.controller,
                    obscureText: isShowText,
                    focusNode: widget.currentNode,
                    keyboardType: widget.textInputType,
                    onFieldSubmitted: (String v) {
                      if (widget.submitFunc != null) {
                        widget.submitFunc!();
                      } else {
                        if (widget.currentNode != null) {
                          widget.currentNode!.unfocus();
                        }
                      }
                    },
                    cursorColor: const Color(0xFF00A780),
                    decoration: InputDecoration(
                      hintStyle: widget.hintStyle ??
                          const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                      hintText: widget.hintText,
                      fillColor: widget.fillColor ??
                          (widget.controller.text.isNotEmpty
                              ? Colors.white
                              : Colors.white),
                      filled: true,
                      isDense: true,
                      errorStyle: const TextStyle(height: 0.01, fontSize: 0),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFF00A780),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.red,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey),
                      ),
                      contentPadding: widget.contentPadding ??
                          const EdgeInsets.fromLTRB(12, 18, 4, 18),
                    ),
                    onTap: widget.onTap,
                    onChanged: widget.onChanged,
                  ),
                ),
              ],
            ),
          ),
          _errBuilder(),
        ],
      ),
    );
  }

  Widget _errBuilder() {
    return errText != null
        ? Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errText!,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.normal),
              maxLines: 3,
              textAlign: TextAlign.start,
            ),
          )
        : const SizedBox();
  }
}
