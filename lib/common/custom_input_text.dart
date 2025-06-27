import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputText extends StatefulWidget {
  const CustomInputText(
      {super.key,
      required this.hintText,
      required this.controller,
      this.focusNode,
      this.title = '',
      this.obscureText = false,
      this.iconNextTextInputAction = TextInputAction.next,
      this.textCapitalization = TextCapitalization.none,
      this.textInputType = TextInputType.text,
      this.inputFormatters,
      this.isReadOnly = false,
      this.maxLines = 1,
      this.minLines = 1,
      this.fontSize = 16,
      this.fillColor,
      this.scrollPadding,
      this.textAlign,
      this.textStyle,
      this.hintStyle,
      this.validator,
      this.marginTop = 10,
      this.borderRadius = 0,
      this.enabledBorder = false,
      this.showRequired = true,
      this.onTap,
      this.onChanged});

  final EdgeInsets? scrollPadding;
  final String title;
  final Color? fillColor;
  final double borderRadius;
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool isReadOnly;
  final TextInputAction iconNextTextInputAction;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? minLines;
  final double fontSize;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextAlign? textAlign;
  final String? Function(String?)? validator;
  final double marginTop;
  final bool enabledBorder;
  final bool showRequired;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  String? errText;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      if (widget.focusNode?.hasFocus == false) {
        widget.controller.text = widget.controller.text.trim();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: widget.marginTop),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (widget.title.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(children: [
                        Text(widget.title,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        if (widget.showRequired)
                          const Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Icon(Icons.error,
                                  color: Colors.red, size: 12))
                      ]),
                    )
                  : const SizedBox(),
              Row(
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
                      style: widget.textStyle ?? const TextStyle(fontSize: 14),
                      validator: (value) {
                        if (widget.validator != null) {
                          setState(() => errText = widget.validator!(value));
                          return widget.validator!(value);
                        }
                        return null;
                      },
                      textInputAction: widget.iconNextTextInputAction,
                      controller: widget.controller,
                      obscureText: widget.obscureText,
                      focusNode: widget.focusNode,
                      keyboardType: widget.textInputType,
                      cursorColor: const Color(0xFF00A780),
                      decoration: InputDecoration(
                          hintStyle: widget.hintStyle ??
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          hintText: widget.hintText,
                          fillColor: widget.fillColor ?? Colors.white,
                          filled: true,
                          isDense: true,
                          errorStyle:
                              const TextStyle(height: 0.01, fontSize: 0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              borderSide: const BorderSide(
                                  width: 1, color: Color(0xFF00A780))),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.red)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.grey)),
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 18, 4, 18)),
                      onTap: widget.onTap,
                      onChanged: widget.onChanged,
                    ))
                  ]),
              _errBuilder(),
            ]));
  }

  Widget _errBuilder() {
    return errText != null
        ? Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(errText!,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.normal),
                maxLines: 2,
                textAlign: TextAlign.start))
        : const SizedBox();
  }
}
