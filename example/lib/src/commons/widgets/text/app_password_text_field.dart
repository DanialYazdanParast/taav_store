import 'package:example/src/commons/widgets/text/app_input_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';

enum PasswordStrength { weak, moderate, strong }

class AppPasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final bool isEnabled;
  final bool showCriteria;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;

  // Customization
  final Color? bgColor;
  final double? width;
  final bool isTapOutsideActive;

  const AppPasswordTextField({
    super.key,
    this.controller,
    this.labelText = "رمز عبور",
    this.hintText = "••••••••",
    this.helperText,
    this.isEnabled = true,
    this.showCriteria = true, // پیش‌فرض روشن
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.bgColor,
    this.width,
    this.isTapOutsideActive = true,
  });

  @override
  State<AppPasswordTextField> createState() => _AppPasswordTextFieldState();
}

class _AppPasswordTextFieldState extends State<AppPasswordTextField> {
  // State Variables
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  bool _isObscureText = true;
  bool _isFocused = false;
  String _password = '';

  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'[0-9]');
  static final RegExp _hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    // لیسنر فوکوس برای نمایش/مخفی کردن باکس معیارها
    _focusNode.addListener(() {
      if (mounted) {
        setState(() => _isFocused = _focusNode.hasFocus);
      }
    });

    // لیسنر متن برای محاسبه قدرت پسورد به صورت ریل‌تایم
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final newText = _controller.text;
    if (_password != newText) {
      setState(() => _password = newText);
      widget.onChanged?.call(newText);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    _focusNode.dispose();
    super.dispose();
  }

  // --- Logic Checks ---
  bool get hasUppercase => _password.contains(_hasUppercase);
  bool get hasLowercase => _password.contains(_hasLowercase);
  bool get hasDigit => _password.contains(_hasDigit);
  bool get hasSpecialChar => _password.contains(_hasSpecialChar);
  bool get hasMinLength => _password.length >= 8;

  PasswordStrength get _strength {
    int score = 0;
    if (hasUppercase) score++;
    if (hasLowercase) score++;
    if (hasDigit) score++;
    if (hasSpecialChar) score++;
    if (hasMinLength) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.moderate;
    return PasswordStrength.strong;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Text Field
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.isEnabled,
            obscureText: _isObscureText,
            textInputAction: widget.textInputAction,
            keyboardType: TextInputType.visiblePassword,
            style: AppInputStyles.textStyle,

            onFieldSubmitted: widget.onFieldSubmitted,
            onEditingComplete: widget.onEditingComplete,

            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,

            onTapOutside: (event) {
              if (widget.isTapOutsideActive) {
                FocusScope.of(context).unfocus();
              }
            },

            // جلوگیری از تایپ فارسی یا فاصله (Space)
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')), // حذف فاصله
              // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]')), // فقط کاراکترهای مجاز
            ],

            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: AppInputStyles.labelStyle,
              hintText: widget.hintText,
              hintStyle: AppInputStyles.hintStyle,
              helperText: widget.helperText,
              helperStyle: AppInputStyles.helperStyle,
              filled: widget.bgColor != null,
              fillColor: widget.bgColor,

              // Borders from AppInputStyles
              border: AppInputStyles.normalBorder,
              enabledBorder: AppInputStyles.normalBorder,
              focusedBorder: AppInputStyles.focusedBorder,
              errorBorder: AppInputStyles.errorBorder,
              focusedErrorBorder: AppInputStyles.focusedErrorBorder,
              disabledBorder: AppInputStyles.disabledBorder,

              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSize.p16,
                vertical: AppSize.p12,
              ),

              // Toggle Eye Icon
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Get.theme.colorScheme.onSurfaceVariant,
                ),
                onPressed:
                    () => setState(() => _isObscureText = !_isObscureText),
              ),
            ),
          ),

          // 2. Criteria Card (هنگام فوکوس نمایش داده می‌شود)
          if (widget.showCriteria && _isFocused) _buildCriteriaCard(),

          // 3. Strength Indicator (هنگام عدم فوکوس و وجود متن نمایش داده می‌شود)
          if (!_isFocused && _password.isNotEmpty && widget.showCriteria) ...[
            AppSize.p8.height,
            _buildStrengthIndicator(),
          ],
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildCriteriaCard() {
    return Container(
      margin: EdgeInsets.only(top: AppSize.p8),
      padding: EdgeInsets.all(AppSize.p12),
      decoration: ShapeDecoration(
        color: Get.theme.colorScheme.surfaceContainer, // رنگ پس‌زمینه باکس
        shape: RoundedRectangleBorder(
          borderRadius: AppSize.brMedium,
          side: BorderSide(
            color: Get.theme.colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRequirementRow('حداقل ۸ کاراکتر', hasMinLength),
          _buildRequirementRow(
            'حداقل یک حرف بزرگ و کوچک',
            hasLowercase && hasUppercase,
          ),
          _buildRequirementRow('حداقل یک عدد', hasDigit),
          _buildRequirementRow('کاراکتر ویژه (@ # \$ %)', hasSpecialChar),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color:
                isMet ? Colors.green : Get.theme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          AppSize.p8.width,
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppSize.f12,
                color:
                    isMet
                        ? Get.theme.colorScheme.onSurface
                        : Get.theme.colorScheme.onSurfaceVariant,
                // اگر شرط پاس شده، متن خط بخورد (اختیاری)
                decoration: isMet ? TextDecoration.none : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthIndicator() {
    final strength = _strength;

    Color getColor(int index) {
      if (strength == PasswordStrength.weak) {
        return index == 0
            ? Colors.red
            : Get.theme.colorScheme.surfaceContainerHighest;
      }
      if (strength == PasswordStrength.moderate) {
        return index <= 1
            ? Colors.orange
            : Get.theme.colorScheme.surfaceContainerHighest;
      }
      return Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: getColor(index),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }
}
