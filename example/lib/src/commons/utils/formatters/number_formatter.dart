class FormatUtil {
  static final RegExp thousands = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  static String currency(double amount) {
    return amount.toStringAsFixed(0)
        .replaceAllMapped(thousands, (m) => '${m[1]},');
  }
}
