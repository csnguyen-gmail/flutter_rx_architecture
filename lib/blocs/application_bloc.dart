import 'dart:async';

import 'package:flutter_rx_architecture/blocs/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';


class ApplicationBloc implements BlocBase {
  // Data
  int _totalMoney = 0;

  // RX + Stream
  BehaviorSubject<String> _getTotalMoneySubject = BehaviorSubject<String>();
  Stream<String> get outTotalMoney => _getTotalMoneySubject.stream;

  StreamController<int> _addMoneyController = StreamController<int>();
  Sink<int> get inTotalMoney => _addMoneyController.sink;


  ApplicationBloc() {
    _addMoneyController.stream.listen((int price) {
      _totalMoney += price;
      _getTotalMoneySubject.add("$_totalMoney");
    });
    // Update data on startup
    _getTotalMoneySubject.add("$_totalMoney");
  }

  void dispose() {
    _getTotalMoneySubject.close();
    _addMoneyController.close();
  }
}

//import 'package:flutter_rx_architecture/blocs/bloc_provider.dart';
//import 'package:rx_command/rx_command.dart';
//
//class ApplicationBloc implements BlocBase {
//  // Data
//  int _totalMoney = 0;
//
//  // RxCommand
//  RxCommand<int, String> moneyCommand;
//
//  ApplicationBloc() {
//
//    moneyCommand = RxCommand.createSync<int, String>((int price){
//      _totalMoney += price;
//      return "$_totalMoney";
//    }, emitsLastValueToNewSubscriptions: true);
//
//    // Update data on startup
//    moneyCommand.execute(0);
//  }
//
//  void dispose() {
//    moneyCommand.dispose();
//  }
//}