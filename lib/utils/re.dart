class RE {
  static const bookName = r'.+[\/](.*?)\.txt';
  static const bookCatalog = r'[\n\r]*?(第.*?章.*)[\n\r]+';
  static const bookCatalog_p = r'[\n\r]*^([^\u3000\n\r]+)[\n\r]*';
}
