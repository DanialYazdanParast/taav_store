enum CurrentState { idle, loading, loadingMore, success, error }

enum UserType { buyer, seller }



UserType? userTypeFromString(String value) {
  switch (value.toLowerCase()) {
    case 'seller':
      return UserType.seller;
    case 'buyer':
      return UserType.buyer;
    default:
      return null;
  }
}
