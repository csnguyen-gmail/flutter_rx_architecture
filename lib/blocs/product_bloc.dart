import 'dart:convert';
import 'package:flutter_rx_architecture/api/entities/product.dart';
import 'package:flutter_rx_architecture/blocs/bloc_provider.dart';
import 'package:flutter_rx_architecture/api/product_api.dart';
import 'package:rx_command/rx_command.dart';


class ProductBloc implements BlocBase {
  // Data
  List<Product> _products;
  String _filter;

  // Command
  RxCommand<void, List<Product>> getProductListCommand;
  RxCommand<String, String> filterChangedCommand;
  RxCommand<void, void> updateProductListCommand;

  ProductBloc() {
    getProductListCommand = RxCommand.createSyncNoParam(
        _getProductList,
        emitsLastValueToNewSubscriptions: true
    );

    filterChangedCommand = RxCommand.createSync((s) => s);
    filterChangedCommand.debounce(Duration(milliseconds: 500)).listen((filterText) {
      _filter = filterText;
      getProductListCommand.execute();
    });

    updateProductListCommand = RxCommand.createAsyncNoParamNoResult(() async {
      var str = await productApi.getProductList();
      var list = json.decode(str) as List<dynamic>;
      _products = list.map((json)=>Product.fromJson(json)).toList();
      getProductListCommand.execute();
    });

    // Update data on startup
    updateProductListCommand.execute();

  }

  List<Product> _getProductList() {
    return _products.where((Product prod) =>
          _filter == null || _filter.isEmpty ||
          prod.name.toUpperCase().startsWith(_filter.toUpperCase())
    ).toList();
  }


  void dispose() {
    getProductListCommand.dispose();
    filterChangedCommand.dispose();
    updateProductListCommand.dispose();
  }
}