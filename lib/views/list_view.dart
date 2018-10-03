import 'package:flutter/material.dart';
import 'package:flutter_rx_architecture/api/entities/product.dart';
import 'package:flutter_rx_architecture/blocs/application_bloc.dart';
import 'package:flutter_rx_architecture/blocs/bloc_provider.dart';
import 'package:flutter_rx_architecture/blocs/product_bloc.dart';

class ProductListView extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  ApplicationBloc _appBloc;
  ProductBloc _prodBloc;
  @override
  void initState() {
    _appBloc = BlocProvider.of<ApplicationBloc>(context);
    _prodBloc = BlocProvider.of<ProductBloc>(context);
    _prodBloc.updateProductListCommand.thrownExceptions.listen((exception) {
      _showDialog(exception.toString());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            TextField(
              onChanged:_prodBloc.filterChangedCommand
            ),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _prodBloc.getProductListCommand,
                builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                  // only if we get data
                  if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    var prodList = snapshot.data;
                    return ListView.builder(
                        itemCount: prodList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Product prod = prodList[index];
                          return Column(
                            children: <Widget>[
                              ListTile(
                                  title: Text(prod.name),
                                  subtitle: Text(prod.company),
                                  trailing: Text("${prod.price}"),
                                  onTap: () => _appBloc.inTotalMoney.add(prod.price)
//                                  onTap: () => _appBloc.moneyCommand.execute(prod.price)
                              ),
                            ],
                          );
                        }
                    );
                  }
                  else {
                    return Text("No items");
                  }
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FlatButton(
                child: Text("Refresh"),
                color: new Color.fromARGB(255, 33, 150, 243),
                textColor: new Color.fromARGB(255, 255, 255, 255),
                onPressed: _prodBloc.updateProductListCommand
              ),
            )
          ],
        ),
        StreamBuilder<bool>(
          stream: _prodBloc.updateProductListCommand.isExecuting,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            // if true we show a indicator
            if (snapshot.hasData && snapshot.data == true) {
              return Container(  // Spinner
                alignment: AlignmentDirectional.center,
                color: Colors.black54,
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }

          }
        ),
      ],
    );
  }

  void _showDialog(String msg) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: new Text(msg),
        actions: <Widget>[
          new FlatButton(child: Text("Close"), onPressed: () => Navigator.of(context).pop())
        ],
      );
    });
  }
}
