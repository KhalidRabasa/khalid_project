import 'package:convertplus/components/gradient_button.dart';
import 'package:convertplus/model/currency.dart';
import 'package:convertplus/services/dataservice.dart';
import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:money_field/money_field.dart';

class NumericTextFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = new NumberFormat("#,###");
      int num = int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(num);
      return new TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // MoneyFieldController baseCurrController = MoneyFieldController(decimalSeparator: '.', thousandsSeparator: ',',maxDigitsBeforeDecimal: 2);

  // MoneyFieldController otherCurrController = MoneyFieldController(decimalSeparator: '.', thousandsSeparator: ',', maxDigitsBeforeDecimal: 2);
  MoneyMaskedTextController baseCurrController =  MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  MoneyMaskedTextController otherCurrController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  String firstCurr = "USD";
  String secondCurr = "EUR";
  String bottom1 = "1 USD = 0.9195 EUR";
  String bottom2 = "1 EUR = 1.0874 USD";
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  bool isLoading = false;
  bool flipped = false;
  CustomCurrency currentSelectedBaseCurrency;
  Map<String, dynamic> rates;
  double currentRate = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    baseCurrController.text = "0";
    otherCurrController.text = "0";
    getCurrencyDetails();
  }

  getCurrencyDetails() {
    setState(() {
      isLoading = true;
    });
    getTheCurrencies(firstCurr).then((result) {
      setState(() {
        isLoading = false;
        currentSelectedBaseCurrency = result;
      });

      if (result == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text('Error'),
              content: new Text('Unable to connect to API'),
              actions: [
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
        return;
      }
      setState(() {
        rates = currentSelectedBaseCurrency.rates;
        flipped = false;
      });
      print('Returned: ${currentSelectedBaseCurrency.rates}');
      calculate();
    });
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  swap() {
    setState(() {
      String temp = firstCurr;
      firstCurr = secondCurr;
      secondCurr = temp;
      temp = bottom1;
      bottom1 = bottom2;
      bottom2 = temp;
      temp = baseCurrController.text;
      baseCurrController.text = otherCurrController.text;
      otherCurrController.text = temp;
      flipped = !flipped;
    });
  }

  calculate() {
    print('Got to calculate');
    if (flipped) {
      getCurrencyDetails();
    }

    if (rates != null) {
      setState(() {
        currentRate = double.parse('${rates[secondCurr]}');
        print('Current rate: $currentRate');
        bottom1 =
            "1 $firstCurr = ${currentRate.toStringAsFixed(3)} $secondCurr";
        bottom2 =
            "1 $secondCurr = ${(1 / currentRate).toStringAsFixed(3)} $firstCurr";
      });
      if (baseCurrController.text == '') {
        otherCurrController.text = "0";
        return;
      }
      if (!flipped) {
        try {
          double amount =
              double.parse('${baseCurrController.text}'.replaceAll(',', ''));
          print('Amount entered: $amount');
          double converted = amount * currentRate;
          setState(() {
            otherCurrController.text = "${removeDecimalZeroFormat(converted)}";
          });
        } catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text('Error'),
                content: new Text('Please enter numbers only'),
                actions: [
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                      baseCurrController.text = "0";
                    },
                  )
                ],
              );
            },
          );
        }
      } else {
        try {
          double amount =
              double.parse('${baseCurrController.text}'.replaceAll(',', ''));
          print('Amount entered: $amount');
          double converted = amount / currentRate;
          print('Converted now: $converted');
          setState(() {
            otherCurrController.text = "${removeDecimalZeroFormat(converted)}";
          });
        } catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text('Error'),
                content: new Text('Please enter numbers only'),
                actions: [
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text('Error'),
            content: new Text('Unable to connect to API'),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }

  Widget _buildDropdownItem(Country country) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: <Widget>[
            Container(
                width: 45,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: CurrencyPickerUtils.getDefaultFlagImage(country)),
            SizedBox(
              width: 15.0,
            ),
            Text(
              "${country.currencyCode} - ${country.currencyName}",
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Color(0xFF7B83B2)),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC6CCE9),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset('assets/logo_transparent.png'),
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      verticalDirection: VerticalDirection.up,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                color: Color(0xFFEBEFFA),
                                margin: EdgeInsets.all(0),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 45, bottom: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => Theme(
                                                      data: Theme.of(
                                                              context)
                                                          .copyWith(
                                                              primaryColor:
                                                                  Colors.pink),
                                                      child:
                                                          CurrencyPickerDialog(
                                                              titlePadding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              searchCursorColor:
                                                                  Colors
                                                                      .pinkAccent,
                                                              searchInputDecoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          'Search...'),
                                                              isSearchable:
                                                                  true,
                                                              title: Text(
                                                                  'Select Currency'),
                                                              onValuePicked:
                                                                  (country) {
                                                                setState(() {
                                                                  secondCurr =
                                                                      country
                                                                          .currencyCode;
                                                                });
                                                                if (flipped) {
                                                                  getCurrencyDetails();
                                                                } else {
                                                                  calculate();
                                                                }
                                                              },
                                                              itemBuilder:
                                                                  _buildDropdownItem)));
                                            },
                                            child: (Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '$secondCurr',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xFF7B83B2)),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Icon(Icons.keyboard_arrow_down,
                                                    color: Color(0xFF7B83B2))
                                              ],
                                            )),
                                          ),
                                          Flexible(
                                              child: TextField(
                                            enabled: false,
                                            style: TextStyle(fontSize: 25),
                                            controller: otherCurrController,
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none),
                                          )),
                                        ],
                                      ),
                                      // SizedBox(height: 5,),
                                      Text(
                                        '$bottom2',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.all(0),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 45, bottom: 40),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          //                             CurrencyPickerDropdown(
                                          //   initialValue: 'tr',
                                          //   itemBuilder: _buildDropdownItem,
                                          //   onValuePicked: (Country country) {
                                          //     print("${country.name}");
                                          //   },
                                          // )
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => Theme(
                                                      data: Theme.of(
                                                              context)
                                                          .copyWith(
                                                              primaryColor:
                                                                  Colors.pink),
                                                      child:
                                                          CurrencyPickerDialog(
                                                              titlePadding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              searchCursorColor:
                                                                  Colors
                                                                      .pinkAccent,
                                                              searchInputDecoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          'Search...'),
                                                              isSearchable:
                                                                  true,
                                                              title: Text(
                                                                  'Select Currency'),
                                                              onValuePicked:
                                                                  (country) {
                                                                setState(() {
                                                                  firstCurr =
                                                                      country
                                                                          .currencyCode;
                                                                });
                                                                getCurrencyDetails();
                                                              },
                                                              itemBuilder:
                                                                  _buildDropdownItem)));
                                            },
                                            child: (Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '$firstCurr',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xFF7B83B2)),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Icon(Icons.keyboard_arrow_down,
                                                    color: Color(0xFF7B83B2))
                                              ],
                                            )),
                                          ),
                                          Flexible(
                                              child: TextField(
                                            onChanged: (newText) {
                                              // baseCurrController.text = oCcy.format(double.parse(newText));
                                              // print(
                                              //     '${oCcy.format(double.parse(newText))}');
                                              calculate();
                                            },
                                            enabled: true,
                                            keyboardType:
                                                TextInputType.number,
                                            style: TextStyle(fontSize: 25),
                                            controller: baseCurrController,
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none),
                                          )),
                                        ],
                                      ),
                                      // SizedBox(height: 5,),
                                      Text(
                                        '$bottom1',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 40,
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     swap();
                          //   },
                          //   child:
                          //  Card(
                          //   elevation: 15,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(25.0),
                          //   ),
                          //   child: Container(
                          //     width: 50,
                          //     height: 50,
                          //     child: Center(
                          //       child: Icon(
                          //         Icons.swap_vert,
                          //         color: Color(0xFF4638DE),
                          //         size: 23,
                          //       ),
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(25)),
                          //       // boxShadow: [BoxShadow(color: Color(0x22333333),blurRadius: 5,spreadRadius: 5)]
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: RaisedButton(
                              color: Colors.white,
                              padding: EdgeInsets.all(0),
                              highlightColor: Color(0xFFCCCCCC),
                              onPressed: () {
                                swap();
                              },
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.swap_vert,
                                  color: Color(0xFF4638DE),
                                  size: 23,
                                ),
                              ),
                            ),
                          ),
                          // )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                // width: 150,
                child: MyGradientButton(
                    width: 150,
                    child: Text(
                      'Convert',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    gradient: LinearGradient(
                        colors: <Color>[Color(0xFF4354e6), Color(0xFF7681e4)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                    radius: 25,
                    onPressed: () {
                      calculate();
                    }),
              ),
            ],
          ),
          isLoading
              ? Container(
                  decoration: BoxDecoration(color: Color(0x88777777)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Container(
                      width: 50,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineScaleParty,
                        color: Color(0xFF3B5DF8),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
