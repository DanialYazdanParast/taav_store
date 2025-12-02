import 'package:example/src/commons/widgets/text/app_input_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';

class AppTextField extends StatefulWidget {
  final String? labelText;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final FormFieldSetter<String>? onSaved;

  final FocusNode? focusNode;

  final bool isEnabled;
  final bool isReadOnly;
  final bool isObscureText;
  final bool isAutoFocus;

  final int? maxLength;
  final int? minLines;
  final int? maxLines;

  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  final TextAlign textAlign;
  final TextDirection? textDirection;

  final String? helperText;
  final String? hintText;

  final String? prefixText;
  final Widget? prefixWidget;
  final String? suffixText;
  final Widget? suffixIcon;
  final Widget? suffixWidget;
  final BoxConstraints? suffixIconConstraints;

  final Color? bgColor;
  final double? width;
  final double? height;

  final bool isShowCheckmark;
  final EdgeInsets? contentPadding;
  final bool isFaConvert;
  final bool isPersianOnly;
  final bool hideErrorText;
  final bool enableScrollPadding;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.autoValidateMode,
    this.onTap,
    this.onSaved,
    this.onEditingComplete,
    this.focusNode, // دریافت از بیرون
    this.isEnabled = true,
    this.isObscureText = false,
    this.isReadOnly = false,
    this.isAutoFocus = false,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.helperText,
    this.hintText,
    this.prefixText,
    this.prefixWidget,
    this.suffixText,
    this.suffixIcon,
    this.suffixWidget,
    this.suffixIconConstraints,
    this.bgColor,
    this.width,
    this.height,
    this.isShowCheckmark = false,
    this.contentPadding,
    this.isFaConvert = true,
    this.isPersianOnly = false,
    this.hideErrorText = false,
    this.enableScrollPadding = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);

  late FocusNode _focusNode;
  bool _isInternalFocusNode = false;

  @override
  void initState() {
    super.initState();
    // اگر فوکوس نود از بیرون آمد، همان را استفاده کن. اگر نه، یکی بساز.
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _isInternalFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    }
  }

  @override
  void dispose() {
    // فقط اگر خودمان ساختیم، نابودش کنیم
    if (_isInternalFocusNode) {
      _focusNode.dispose();
    }
    _isValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        controller: widget.controller,
        initialValue: widget.initialValue,
        enabled: widget.isEnabled,
        readOnly: widget.isReadOnly,
        obscureText: widget.isObscureText,
        autofocus: widget.isAutoFocus,
        focusNode: _focusNode, // استفاده از نود صحیح

        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted, // اتصال دکمه کیبورد
        onEditingComplete: widget.onEditingComplete,
        onSaved: widget.onSaved,
        onTap: widget.onTap,
        onTapOutside: (event) {
          if (_isInternalFocusNode) {
            FocusScope.of(context).unfocus();
          }
        },

        style: AppInputStyles.textStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        cursorColor: Get.theme.colorScheme.primary,

        autovalidateMode: widget.autoValidateMode,
        validator: (value) {
          final result = widget.validator?.call(value);
          if (mounted) {
            _isValidNotifier.value =
                result == null && (value?.isNotEmpty ?? false);
          }
          return result;
        },

        maxLength: widget.maxLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines == 0 ? null : widget.maxLines,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,

        inputFormatters: [
          if (widget.keyboardType == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly,
          ...?widget.inputFormatters,
        ],

        scrollPadding:
            widget.enableScrollPadding
                ? EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 100,
                )
                : const EdgeInsets.all(20.0),

        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: AppInputStyles.labelStyle,
          hintText: widget.hintText,
          hintStyle: AppInputStyles.hintStyle,
          helperText: widget.helperText,
          helperStyle: AppInputStyles.helperStyle,
          counterText: '',
          filled: widget.bgColor != null,
          fillColor: widget.bgColor,
          border: AppInputStyles.normalBorder,
          enabledBorder: AppInputStyles.normalBorder,
          focusedBorder: AppInputStyles.focusedBorder,
          errorBorder: AppInputStyles.errorBorder,
          focusedErrorBorder: AppInputStyles.focusedErrorBorder,
          disabledBorder: AppInputStyles.disabledBorder,
          errorStyle:
              widget.hideErrorText
                  ? const TextStyle(height: 0, fontSize: 0)
                  : AppInputStyles.errorStyle,
          contentPadding:
              widget.contentPadding ??
              EdgeInsets.symmetric(
                horizontal: AppSize.p16,
                vertical: AppSize.p10,
              ),
          prefixText: widget.prefixText,
          prefixStyle: AppInputStyles.prefixStyle,
          prefixIcon: _buildPrefix(),
          suffixText: widget.suffixText,
          suffixStyle: AppInputStyles.prefixStyle,
          suffixIconConstraints: widget.suffixIconConstraints,
          suffixIcon: widget.suffixIcon,
          suffix: widget.suffixWidget,
        ),
      ),
    );
  }

  Widget? _buildPrefix() {
    if (widget.prefixWidget == null && !widget.isShowCheckmark) return null;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.p8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSize.p4.width,
          if (widget.prefixWidget != null) widget.prefixWidget!,
          if (widget.isShowCheckmark)
            ValueListenableBuilder<bool>(
              valueListenable: _isValidNotifier,
              builder: (context, isValid, child) {
                if (!isValid) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(right: AppSize.p8),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
