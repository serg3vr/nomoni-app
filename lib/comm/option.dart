class Option {
  const Option(this.key, this.value); 

  final String key;
  final String value;

  static List<Option> map(List<dynamic> list) {
    if (list.length > 0) {
      return list.map((dynamic option) {
        return Option(option['value'].toString(), option['label'].toString());
      }).toList();
    }
    return [];
  }
}