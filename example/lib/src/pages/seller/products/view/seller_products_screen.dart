import 'package:example/src/commons/constants/app_png.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/utils/toast_util.dart';
import 'package:example/src/commons/widgets/app_shimmer.dart';
import 'package:example/src/commons/widgets/bottom_sheet.dart';
import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/commons/widgets/dialog_widget.dart';
import 'package:example/src/commons/widgets/divider_widget.dart';
import 'package:example/src/commons/widgets/text/app_password_text_field.dart';
import 'package:example/src/commons/widgets/text/app_text_field.dart';
import 'package:example/src/infoStructure/languages/localization_controller.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class SellerProductsScreen extends StatefulWidget {
  SellerProductsScreen({super.key});

  @override
  State<SellerProductsScreen> createState() => _SellerProductsScreenState();
}

class _SellerProductsScreenState extends State<SellerProductsScreen> {
  // متغیر محلی برای مدیریت تب انتخاب شده (فقط برای تست UI)
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final locController = Get.find<LocalizationController>();

    final _usernameCtrl = TextEditingController();
    final _passwordCtrl = TextEditingController();
    final _phoneCtrl = TextEditingController();

    // متغیر برای نمایش/مخفی کردن پسورد
    bool _isPasswordVisible = false;

    return Scaffold(
      appBar: AppBar(
        title: Text(TKeys.appTitle.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => locController.toggleLocale(),
            tooltip: 'تغییر زبان',
          ),
        ],
      ),

      // بدنه اصلی (همان تست‌های قبلی)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Chip(
                label: Text(
                  "زبان: ${Get.locale?.languageCode.toUpperCase()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.amber.shade100,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "تست جهت (Row):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  const Icon(Icons.start, color: Colors.green), // فارسی: راست
                  const SizedBox(width: 10),
                  const Text("Start"),
                  const Spacer(),
                  const Text("End"),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.abc_outlined,
                    color: Colors.red,
                  ), // فارسی: چپ
                ],
              ),
            ),

            SizedBox(height: 20),
            ButtonWidget(
              "دکمه fffffffffffffffffغیرفعال",
              () {},
              isLoading: true,
              //isEnabled: false, // تست حالت غیرفعال
              // icon: Icons.block,
              bgColor: Colors.grey,
            ).material(),

            AppShimmer.circle(size: 50),

            SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // خط بلند (نام)
                AppShimmer.rect(width: 150, height: 16),
                SizedBox(height: 8),
                // خط کوتاه (زیرعنوان)
                AppShimmer.rect(width: 100, height: 12),
              ],
            ),

            AppPasswordTextField(
              //        controller: _passwordController,
              labelText: "رمز عبور جدید",
              hintText: "مثلاً: P@ssw0rd123",

              // این ویژگی مهم است: نمایش باکس قوانین
              showCriteria: true,

              // ولیدیشن نهایی فرم
              validator: (value) {
                if (value == null || value.length < 8) {
                  return "رمز عبور کوتاه‌تر از حد مجاز است";
                }
                return null;
              },
            ),
            // -----------------------------------------------------------
            // 1. ساده (Simple)
            // -----------------------------------------------------------
            const Text("۱. فیلد ساده (با تیک سبز اعتبارسنجی)"),
            AppSize.p8.height,

            AppTextField(
              controller: _usernameCtrl,
              labelText: "نام کاربری",
              hintText: "مثلاً: ali_reza",
              prefixWidget: const Icon(Icons.person_outline),

              // فعال کردن تیک سبز
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.length < 4) {
                  return "نام کاربری باید حداقل ۴ حرف باشد";
                }
                return null;
              },
            ),

            const Divider(height: 40),

            // -----------------------------------------------------------
            // 2. رمز عبور (Password)
            // -----------------------------------------------------------
            const Text("۲. رمز عبور (با دکمه چشم)"),
            AppSize.p8.height,

            AppTextField(
              controller: _passwordCtrl,
              labelText: "رمز عبور",
              hintText: "••••••••",
              // مدیریت وضعیت نمایش متن
              isObscureText: !_isPasswordVisible,
              maxLines: 1,
              prefixWidget: const Icon(Icons.lock_outline),

              // دکمه چشم در انتهای فیلد
              suffixWidget: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),

            const Divider(height: 40),

            // -----------------------------------------------------------
            // 3. عددی / موبایل (Numeric)
            // -----------------------------------------------------------
            const Text("۳. شماره موبایل (فقط عدد + محدودیت طول)"),
            AppSize.p8.height,

            AppTextField(
              controller: _phoneCtrl,
              labelText: "شماره موبایل",
              hintText: "0912...",
              keyboardType: TextInputType.phone,
              maxLength: 11, // محدودیت طول
              prefixText: "+98", // کد کشور ثابت
              prefixWidget: const Icon(Icons.phone_android),
              // اجبار به تایپ انگلیسی (اختیاری)
              isFaConvert: true,
              validator: (value) {
                if (value != null && !value.startsWith('09')) {
                  return "شماره باید با 09 شروع شود";
                }
                return null;
              },
            ),

            const Divider(height: 40),

            // -----------------------------------------------------------
            // 4. مالی / قیمت (Suffix Text)
            // -----------------------------------------------------------
            const Text("۴. مبلغ (با متن انتهایی)"),
            AppSize.p8.height,

            AppTextField(
              labelText: "مبلغ واریزی",
              hintText: "0",
              suffixText: "تومان", // متن ثابت انتها
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                // اگر فرمتر ۳ رقم ۳ رقم دارید اینجا اضافه کنید
              ],
            ),

            const Divider(height: 40),

            // -----------------------------------------------------------
            // 5. جستجو (Filled Style)
            // -----------------------------------------------------------
            const Text("۵. جستجو (استایل توپر)"),
            AppSize.p8.height,

            AppTextField(
              hintText: "جستجو در محصولات...",
              bgColor: Get.theme.colorScheme.surfaceContainerHighest
                  .withOpacity(0.5),
              prefixWidget: const Icon(Icons.search),
              // حذف بوردر پیش‌فرض برای ظاهر مدرن‌تر
              // نکته: اگر بخواهید کلاً بوردر نداشته باشد باید در ویجت اصلی border: InputBorder.none بگذارید
              // اما اینجا فقط رنگ زمینه دادیم که کافیست.
            ),

            const Divider(height: 40),

            // -----------------------------------------------------------
            // 6. توضیحات (Multi-line)
            // -----------------------------------------------------------
            const Text("۶. توضیحات (چند خطی)"),
            AppSize.p8.height,

            const AppTextField(
              labelText: "توضیحات تکمیلی",
              hintText: "پیام خود را اینجا بنویسید...",
              minLines: 3,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              // آیکون بالا سمت راست قرار می‌گیرد
              prefixWidget: Padding(
                padding: EdgeInsets.only(
                  bottom: 40,
                ), // تراز کردن آیکون با خط اول
                child: Icon(Icons.comment_outlined),
              ),
            ),

            AppSize.p32.height,

            ButtonWidget(
              "خروج از حساب",
              () {
                BottomSheetWidget(
                  showDragHandle: true,
                  isDismissible: true,
                  isScrollControlled: true,
                ).show(Container(height: 500, color: Colors.red));
              },
              opensPage: true, // فلش کوچک کنار متن می‌گذارد
            ).material(),

            AppDivider.horizontal(),

            Text("آیتم دوم"),

            // ۲. دیوایدر کوچک وسط‌چین
            Center(child: AppDivider.horizontal(width: 100, color: Colors.red)),

            ButtonWidget(
              "فراموشی رمز عبور؟",
              () {
                DialogWidget(
                  isDismissible: true,
                ).show(Container(height: 300, color: Colors.red));
              },
              fontSize: AppSize.f12,
              textColor: Colors.teal,
            ).textOnly(),

            ButtonWidget(
              "مشاهده همه",
              () {},
              opensPage: true, // فلش کوچک کنار متن می‌گذارد
            ).textOnly(),

            GestureDetector(
              onTap: () {
                ToastUtil.show(
                  'امdddddddddddddddgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd شد',
                  type: ToastType.warning,
                  position: SnackPosition.TOP,
                );
              },
              child: Image.asset(
                AppPng.logo,
                width: 300,
                height: 300,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      // --- تست BottomNavigationBar ---
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: selectedIndex.value,
          onDestinationSelected: (index) => selectedIndex.value = index,
          // جهت چیدمان این دکمه‌ها در فارسی و انگلیسی باید برعکس شود
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'خانه', // آیتم اول
            ),
            NavigationDestination(
              icon: Icon(Icons.store_outlined),
              selectedIcon: Icon(Icons.store),
              label: 'محصولات', // آیتم دوم (وسط)
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'پروفایل', // آیتم سوم
            ),
          ],
        ),
      ),
    );
  }
}
