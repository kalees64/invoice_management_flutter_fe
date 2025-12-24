class Helper {
  static String capitalizeFirstLetter(String string) {
    return string[0].toUpperCase() + string.substring(1);
  }

  static String makeWordAsTitle(String string) {
    return string
        .split('_')
        .map((word) => capitalizeFirstLetter(word))
        .join(' ');
  }
}
