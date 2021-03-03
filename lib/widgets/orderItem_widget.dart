import 'package:flutter/material.dart';
import 'package:restaurant/themes/colors.dart';

class OrderItem extends StatefulWidget {
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accentLighter,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Customer Name: ABC",
            style: TextStyle(color: AppColors.redText),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID: XXXXXX",
                style: TextStyle(color: AppColors.redText),
              ),
              Text(
                "Time and Date",
                style: TextStyle(color: AppColors.redText),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 30),
          Text("Items:", style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          DishItem(),
          DishItem(),
          DishItem(),
          SizedBox(height: 20),
          Text(
            "Paid By: Card Name",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.green,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Text(
                  "Pick Up at: HH:MM",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColors.green,
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  width: 35,
                  height: 35,
                  child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    color: AppColors.green,
                    child: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text("Edit Pickup Time",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 25),
                            children: [
                              Divider(),
                              TextField(
                                // minLines: 6,
                                // maxLines: 6,
                                decoration: InputDecoration(
                                  hintText: "Enter here",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding:
                                      EdgeInsets.only(left: 10, top: 15),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  color: Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Save",
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ]),
              // Row(children: [
              //   SizedBox(
              //     width: 35,
              //     height: 35,
              //     child: RaisedButton(
              //       padding: EdgeInsets.all(0),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       elevation: 0,
              //       color: AppColors.green,
              //       child: Icon(Icons.check, color: Colors.white),
              //       onPressed: () {},
              //     ),
              //   ),
              //   SizedBox(width: 20),
              //   SizedBox(
              //     width: 35,
              //     height: 35,
              //     child: RaisedButton(
              //       padding: EdgeInsets.all(0),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       elevation: 0,
              //       onPressed: () {},
              //       color: AppColors.redText,
              //       child: Icon(Icons.close, color: Colors.white),
              //     ),
              //   ),
              // ]),
              RaisedButton(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                elevation: 0,
                color: Colors.white,
                textColor: Theme.of(context).primaryColor,
                child: Text("Mark Picked Up",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DishItem extends StatelessWidget {
  const DishItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: Color.fromRGBO(0, 0, 0, 0.1)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Dish Name"),
            FlatButton.icon(
              textColor: AppColors.green,
              label: Text(
                "View Add On",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              icon: Icon(
                Icons.description_rounded,
                color: AppColors.green,
              ),
              onPressed: () {
                int _isRadioSelected = 1;
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return ListTileTheme(
                          iconColor: AppColors.green,
                          textColor: AppColors.green,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                toggleableActiveColor: AppColors.green),
                            child: SimpleDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(
                                "Select Restaurant",
                                style: Theme.of(context).textTheme.headline3,
                                textAlign: TextAlign.center,
                              ),
                              titlePadding: EdgeInsets.only(top: 15),
                              children: [
                                Text("Extra Cheese: 1x",
                                    textAlign: TextAlign.center),
                                Text("Extra Cheese: 1x",
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              },
            ),
            FlatButton.icon(
              textColor: AppColors.green,
              label: Text(
                "View Order Note",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              icon: Icon(
                Icons.description_rounded,
                color: AppColors.green,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return ListTileTheme(
                          iconColor: AppColors.green,
                          textColor: AppColors.green,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                toggleableActiveColor: AppColors.green),
                            child: SimpleDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(
                                "Order Note",
                                style: Theme.of(context).textTheme.headline3,
                                textAlign: TextAlign.center,
                              ),
                              titlePadding: EdgeInsets.only(top: 15),
                              contentPadding: EdgeInsets.all(15),
                              children: [
                                Divider(),
                                Text(
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor. Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor",
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              },
            ),
            Text("Qty"),
            Text("Price"),
          ],
        ),
      ),
    );
  }
}
