//import 'dart:async';
//
//import 'package:flutter_rx_architecture/blocs/bloc_provider.dart';
//import 'package:rxdart/rxdart.dart';
//
//
//class ApplicationBloc implements BlocBase {
//  // Data
//  int _totalMoney;
//
//  // RX + Stream
//  BehaviorSubject<String> _getTotalMoneySubject = BehaviorSubject<String>();
//  Stream<String> get getTotalMoneyCommand => _getTotalMoneySubject.stream;
//
//  StreamController<int> _addMoneyController = StreamController<int>();
//  Sink<int> get addMoneyCommand => _addMoneyController.sink;
//
//
//  ApplicationBloc() {
//    _addMoneyController.stream.listen((int price) {
//      _totalMoney += price;
//      _getTotalMoneySubject.add("$_totalMoney");
//    });
//    // Update data on startup
//    _totalMoney = 0;
//    _getTotalMoneySubject.add("$_totalMoney");
//  }
//
//  void dispose() {
//    _getTotalMoneySubject.close();
//    _addMoneyController.close();
//  }
//}

import 'package:flutter_rx_architecture/blocs/bloc_provider.dart';
import 'package:rx_command/rx_command.dart';

class ApplicationBloc implements BlocBase {
  // Data
  int _totalMoney;

  // RxCommand
  RxCommand<void, String> getTotalMoneyCommand;
  RxCommand<int, void> addMoneyCommand;


  ApplicationBloc() {
    getTotalMoneyCommand = RxCommand.createSyncNoParam(
            () => "$_totalMoney", emitsLastValueToNewSubscriptions: true);

    addMoneyCommand = RxCommand.createSyncNoResult<int>((int price) {
      _totalMoney += price;
      getTotalMoneyCommand.execute();
    });

    // Update data on startup
    _totalMoney = 0;
    getTotalMoneyCommand.execute();
  }

  void dispose() {
    /// RxCommand
    getTotalMoneyCommand.dispose();
    addMoneyCommand.dispose();
  }
}