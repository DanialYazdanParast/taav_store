import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/shared/widgets/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedAppBar<T extends GetxController> extends GetView<T> {
  final double screenWidth;
  final bool isRtl;
  final String title;
  final RxBool isSearching;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onFilterTap;

  const AnimatedAppBar({
    super.key,
    required this.screenWidth,
    required this.isRtl,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
    required this.title,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [_buildTitleRow(), _buildAnimatedSearchBar()],
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
              IconButtonWidget(icon: Icons.filter_list, onTap: onFilterTap),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppSize.f18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              48.width,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchBar() {
    return Positioned(
      left: isRtl ? AppSize.p16 : null,
      right: isRtl ? null : AppSize.p16,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
          width: isSearching.value ? screenWidth - 32 : 45,
          height: 45,
          decoration: BoxDecoration(
            color:
                isSearching.value
                    ? Colors.white
                    : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(
              isSearching.value ? AppSize.r12 : AppSize.r10,
            ),
            boxShadow:
                isSearching.value
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: AppSize.p10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Stack(
            alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
            children: [
              if (isSearching.value) _buildSearchTextField(),
              _buildSearchIconButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: isRtl ? 40 : AppSize.p10,
        right: isRtl ? AppSize.p10 : 40,
      ),
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: TKeys.searchHint.tr,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: AppSize.f13),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildSearchIconButton() {
    return Positioned(
      left: isRtl ? 0 : null,
      right: isRtl ? null : 0,
      child: GestureDetector(
        onTap: () {
          isSearching.value = !isSearching.value;

          if (isSearching.value) {
            searchFocusNode.requestFocus();
          } else {
            searchController.clear();
            searchFocusNode.unfocus();
          }
        },
        child: Container(
          width: 45,
          height: 45,
          color: Colors.transparent,
          child: Icon(
            isSearching.value ? Icons.close : Icons.search,
            color: isSearching.value ? Colors.grey : Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
