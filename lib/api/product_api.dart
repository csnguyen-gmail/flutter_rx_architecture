
class ProductApi {
  bool _isError = true; // for demonstration only

  Stream<String> getProductListStream() {
    return Stream.fromFuture(getProductList());
  }

  Future<String> getProductList() async{
    await Future.delayed(Duration(seconds: 1)); //Mock delay
    _isError = !_isError;
    if (_isError) {
      throw Exception("getProductList error");
    }
    return """
    [
      {"name":"car","company":"mercedes","price":10},
      {"name":"airplane","company":"boeing","price":100},
      {"name":"shoe","company":"nike","price":2},
      {"name":"soft drink","company":"cocacola","price":1},
      {"name":"laptop","company":"apple","price":5},
      {"name":"oil","company":"bp","price":1}
    ]
    """;
  }
}

ProductApi productApi = ProductApi();