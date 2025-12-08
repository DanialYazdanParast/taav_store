// translation_keys.dart

abstract class TKeys {
  // ═══ App Info ═══
  static const String appTitle = 'app_title';
  static const String version = 'version';

  // ═══ Auth - Common ═══
  static const String username = 'username';
  static const String password = 'password';
  static const String confirmPassword = 'confirm_password';
  static const String enterUsername = 'enter_username';
  static const String enterPassword = 'enter_password';
  static const String rememberMe = 'remember_me';
  static const String forgotPassword = 'forgot_password';

  // ═══ Login ═══
  static const String welcome = 'welcome';
  static const String loginToContinue = 'login_to_continue';
  static const String loginToAccount = 'login_to_account';
  static const String login = 'login';
  static const String noAccount = 'no_account';
  static const String signUp = 'sign_up';
  static const String helloEmoji = 'hello_emoji';
  static const String signIn = 'sign_in';

  // ═══ Register ═══
  static const String createAccount = 'create_account';
  static const String enterInfoToStart = 'enter_info_to_start';
  static const String signUpEmoji = 'sign_up_emoji';
  static const String createNewAccount = 'create_new_account';
  static const String joinUs = 'join_us';
  static const String thousandsUsersTrust = 'thousands_users_trust';
  static const String chooseUsername = 'choose_username';
  static const String minCharacters = 'min_characters';
  static const String repeatPassword = 'repeat_password';
  static const String accountType = 'account_type';
  static const String buyer = 'buyer';
  static const String seller = 'seller';
  static const String acceptTermsText = 'accept_terms_text';
  static const String termsAndConditions = 'terms_and_conditions';
  static const String acceptTermsSuffix = 'accept_terms_suffix';
  static const String alreadyHaveAccount = 'already_have_account';

  // ═══ Branding Panel / Welcome ═══
  static const String welcomeToApp = 'welcome_to_app';
  static const String smartBusinessManagement = 'smart_business_management';
  static const String highSpeed = 'high_speed';
  static const String fullSecurity = 'full_security';
  static const String support247 = 'support_247';

  // ═══ Navigation ═══
  static const String navHome = 'nav_home';
  static const String navAddProduct = 'nav_add_product';
  static const String navProfile = 'nav_profile';
  static const String navCart = 'nav_cart';

  // ═══ General Buttons & Fields ═══
  static const String searchHint = 'search_hint';
  static const String addProduct = 'add_product';
  static const String cancel = 'cancel';
  static const String add = 'add';
  static const String products = 'products';
  static const String sales = 'sales';

  // ═══ Profile / Settings ═══
  static const String settings = 'settings';
  static const String guestUser = 'guest_user';
  static const String appLanguage = 'app_language';
  static const String selectLanguage = 'select_language';
  static const String farsi = 'farsi';
  static const String english = 'english';
  static const String appTheme = 'app_theme';
  static const String lightMode = 'light_mode';
  static const String darkMode = 'dark_mode';
  static const String systemMode = 'system_mode';
  static const String themeLightTitle = 'theme_light_title';
  static const String themeDarkTitle = 'theme_dark_title';
  static const String logout = 'logout';
  static const String logoutDescMobile = 'logout_desc_mobile';
  static const String logoutDescWeb = 'logout_desc_web';
  static const String confirmLogoutMsg = 'confirm_logout_msg';
  static const String yesLogout = 'yes_logout';
  static const String myOrders = 'my_orders';
  static const String purchaseHistory = 'purchase_history';
  static const String orderHistoryDesc = 'order_history_desc';

  // ═══ Product Details / Item ═══
  static const String productDetails = 'product_details';
  static const String productDescription = 'product_description';
  static const String addToCart = 'add_to_cart';
  static const String outOfStock = 'out_of_stock';
  static const String soldOut = 'sold_out';
  static const String selectedColor = 'selected_color';
  static const String selectColor = 'select_color';
  static const String quantity = 'quantity';
  static const String unit = 'unit';
  static const String piece = 'piece';

  // ═══ Filter Section  ═══
  static const String filters = 'filters';
  static const String removeAll = 'remove_all';
  static const String priceRange = 'price_range';
  static const String currency = 'currency'; // تومان
  static const String toman = 'toman';
  static const String colors = 'colors';
  static const String tags = 'tags';
  static const String onlyAvailable = 'only_available';
  static const String viewResults = 'view_results';

  // ═══ Cart / Order Summary ═══
  static const String cartTitle = 'cart_title';
  static const String orderHistory = 'order_history';
  static const String cartEmpty = 'cart_empty';
  static const String submitOrder = 'submit_order';
  static const String orderSummary = 'order_summary';
  static const String itemsPrice = 'items_price';
  static const String yourSavings = 'your_savings';
  static const String cartTotal = 'cart_total';
  static const String confirmAndPay = 'confirm_and_pay';
  static const String item = 'item';
  static const String items = 'items';
  static const String inCartItems = 'in_cart_items';
  static const String order = 'order';

  // ═══ Order Details / History ═══
  static const String errorLoadingData = 'error_loading_data';
  static const String noOrdersYet = 'no_orders_yet';
  static const String orderDetails = 'order_details';
  static const String orderNumber = 'order_number';

  // ═══ Seller Panel ═══
  static const String sellerPanel = 'seller_panel';
  static const String productManagement = 'product_management';
  static const String shopProductList = 'shop_product_list';
  static const String totalRevenue = 'total_revenue';
  static const String activeProducts = 'active_products';
  static const String successfulSales = 'successful_sales';
  static const String newOrders = 'new_orders';
  static const String stock = 'stock';
  static const String yourProfit = 'your_profit';
  static const String productSalesStats = 'product_sales_stats';
  static const String viewBestSellers = 'view_best_sellers';
  static const String salesReports = 'sales_reports';
  static const String salesStatistics = 'sales_statistics';
  static const String noSalesYet = 'no_sales_yet';
  static const String salesReportTitle = 'sales_report_title';
  static const String soldCount = 'sold_count';
  static const String countUnit = 'count_unit';
  static const String bestSeller = 'best_seller';
  static const String deleteProductTitle = 'delete_product_title';
  static const String confirmDeleteProductMsg = 'confirm_delete_product_msg';
  static const String deleteAction = 'delete_action';

  // ═══ Product Creation / Editing ═══
  static const String addNewProduct = 'add_new_product';
  static const String finalSubmitProduct = 'final_submit_product';
  static const String attributes = 'attributes';
  static const String productImage = 'product_image';
  static const String uploadImage = 'upload_image';
  static const String productTitleHint = 'product_title_hint';
  static const String productTitleLabel = 'product_title_label';
  static const String productDescHint = 'product_desc_hint';
  static const String productDescLabel = 'product_desc_label';
  static const String priceTomanHint = 'price_toman_hint';
  static const String priceLabel = 'price_label';
  static const String discountPriceHint = 'discount_price_hint';
  static const String editProduct = 'edit_product';
  static const String updateProduct = 'update_product';

  // ═══ Buyer Panel ═══
  static const String buyerPanel = 'buyer_panel';

  // ═══ Success / Error Messages - Auth ═══
  static const String loginSuccess = 'login_success';
  static const String welcomeMessage = 'welcome_message';
  static const String invalidUserType = 'invalid_user_type';
  static const String acceptTermsWarning = 'accept_terms_warning';
  static const String usernameAlreadyExists = 'username_already_exists';
  static const String registerSuccessMsg = 'register_success_msg';

  // ═══ Success / Error Messages - Cart / Order ═══
  static const String cartUpdateFailed = 'cart_update_failed';
  static const String addToCartFailed = 'add_to_cart_failed';
  static const String addedToCartSuccess = 'added_to_cart_success';
  static const String itemDeleteFailed = 'item_delete_failed';
  static const String orderSubmitFailed = 'order_submit_failed';
  static const String orderSubmitSuccess = 'order_submit_success';
  static const String fetchOrdersError = 'fetch_orders_error';

  // ═══ Success / Error Messages - Product Management ═══
  static const String stockUpdateSuccess = 'stock_update_success';
  static const String stockFinishedWarning = 'stock_finished_warning';
  static const String permissionDenied = 'permission_denied';
  static const String errorSelectingImage = 'error_selecting_image';
  static const String errorAddingColor = 'error_adding_color';
  static const String newTagAdded = 'new_tag_added';
  static const String errorAddingTag = 'error_adding_tag';
  static const String pleaseFixFormErrors = 'please_fix_form_errors';
  static const String pleaseSelectProductImage = 'please_select_product_image';
  static const String errorAddingProduct = 'error_adding_product';
  static const String productAddedSuccessfully = 'product_added_successfully';
  static const String invalidProductId = 'invalid_product_id';
  static const String errorFetchingProduct = 'error_fetching_product';
  static const String productImageRequired = 'product_image_required';
  static const String errorUpdatingProduct = 'error_updating_product';
  static const String productUpdatedSuccessfully = 'product_updated_successfully';
  static const String fetchProductDetailsError = 'fetch_product_details_error';

  // ═══ Success / Error Messages - General Network / Other ═══
  static const String unexpectedError = 'unexpected_error';
  static const String connectionTimeout = 'connection_timeout';
  static const String sendTimeout = 'send_timeout';
  static const String receiveTimeout = 'receive_timeout';
  static const String timeoutMessage = 'timeout_message';
  static const String requestCancelled = 'request_cancelled';
  static const String connectionError = 'connection_error';
  static const String checkInternetConnection = 'check_internet_connection';
  static const String badCertificate = 'bad_certificate';
  static const String unknownNetworkError = 'unknown_network_error';
  static const String serverErrorOccurred = 'server_error_occurred';

  static const String tagManagement = 'tag_management';
  static const String searchTagHint = 'search_tag_hint';
  static const String tagNotFound = 'tag_not_found';
  static const String searchTagNamePrompt = 'search_tag_name_prompt';
  static const String confirmAndClose = 'confirm_and_close';
  static const String addNewColor = 'add_new_color';
  static const String colorNameHint = 'color_name_hint';
  static const String confirmAndAdd = 'confirm_and_add';
  static const String pleaseEnterColorNameWarning = 'please_enter_color_name_warning';
  static const String cameraSource = 'camera_source';
  static const String imageGallerySource = 'image_gallery_source';

  static const String productDeletedSuccessfully = 'product_deleted_successfully'; // ✅ کلید جدید
}