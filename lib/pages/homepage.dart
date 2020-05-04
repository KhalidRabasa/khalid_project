import 'package:convertplus/components/gradient_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController baseCurrController = TextEditingController();
  TextEditingController otherCurrController = TextEditingController();
  String firstCurr = "USD";
  String secondCurr = "EUR";
  String bottom1 = "1 USD = 0.9195 EUR";
  String bottom2 = "1 EUR = 1.0874 USD";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    baseCurrController.text = "0";
    otherCurrController.text = "0";
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC6CCE9),
      body: ListView(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            margin: EdgeInsets.all(0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 45, bottom: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
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
                                        style: TextStyle(fontSize: 25),
                                        controller: baseCurrController,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            disabledBorder: InputBorder.none,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
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
                                        style: TextStyle(fontSize: 25),
                                        controller: otherCurrController,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            disabledBorder: InputBorder.none,
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
                    )
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
                      InkWell(
                        onTap: () {
                          swap();
                        },
                        child: Card(
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: Icon(
                                Icons.swap_vert,
                                color: Color(0xFF4638DE),
                                size: 23,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              // boxShadow: [BoxShadow(color: Color(0x22333333),blurRadius: 5,spreadRadius: 5)]
                            ),
                          ),
                        ),
                      )
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
                  print('button clicked');
                }),
          ),
        ],
      ),
    );
  }
}
