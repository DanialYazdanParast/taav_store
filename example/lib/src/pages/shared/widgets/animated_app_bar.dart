import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/shared/widgets/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedAppBar<T extends GetxController> extends GetView<T> {
  final double screenWidth;
  final String title;
  final RxBool isSearching;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onSearchChanged;

  const AnimatedAppBar({
    super.key,
    required this.screenWidth,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
    required this.title,
    required this.onFilterTap,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);

    return SizedBox(
      height: 80,
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          _buildTitleRow(),
          _buildAnimatedSearchBar(textDirection),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Obx(
          () => AnimatedOpacity(
        opacity: isSearching.value ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.p16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButtonWidget(
                icon: Icons.filter_list,
                onTap: onFilterTap,
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Get.theme.textTheme.bodyLarge
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchBar(TextDirection textDirection) {
    return Positioned.directional(
      textDirection: textDirection,
      end: AppSize.p16,

      child: Obx(() {
        final isActive = isSearching.value;
        final finalWidth = screenWidth - 32;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
          width: isActive ? finalWidth : 40,
          height: 40,
          clipBehavior: Clip.hardEdge,

          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(isActive ? AppSize.r12 : AppSize.r10),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: Colors.black.withValues(alpha:  0.1),
                blurRadius: AppSize.p10,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),

          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: isActive ? finalWidth : 40,
              height: 40,
              child: isActive
                  ? _buildActiveContent()
                  : Center(child: _buildSearchButton(false)),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActiveContent() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),

            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              onChanged: onSearchChanged,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                hintText: TKeys.searchHint.tr,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),

        // دکمه بستن
        _buildSearchButton(true),
      ],
    );
  }

  Widget _buildSearchButton(bool isActive) {
    return IconButtonWidget(
      onTap: _toggleSearch,
      color: isActive ? Colors.grey[700] : Colors.white,
      icon: isActive ? Icons.close : Icons.search,
    bgColor: Colors.transparent,

    );
  }

  void _toggleSearch() {
    isSearching.value = !isSearching.value;

    if (isSearching.value) {
      searchFocusNode.requestFocus();
    } else {
      searchController.clear();
      onSearchChanged?.call('');
      searchFocusNode.unfocus();
    }
  }
}