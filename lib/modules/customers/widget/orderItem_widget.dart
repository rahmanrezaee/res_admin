import 'package:restaurant/modules/customers/models/orderItem_model.dart';
import 'package:restaurant/modules/customers/models/order_model.dart';
import 'package:flutter/material.dart';
import '../../../themes/colors.dart';

class OrderCardItem extends StatefulWidget {
  final String page;
  final OrderModel order;
  OrderCardItem(this.order, this.page);
  @override
  _OrderCardItemState createState() => _OrderCardItemState();
}

class _OrderCardItemState extends State<OrderCardItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accentLighter,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.page == 'customeProfile'
              ? Container()
              : Text(
                  "Customer Name: ${widget.order.customerName}",
                  style: TextStyle(color: AppColors.redText),
                ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID: ${widget.order.id}",
                style: TextStyle(color: AppColors.redText),
              ),
              Text(
                widget.order.createdAt,
                style: TextStyle(color: AppColors.redText),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 30),
          Text("Items:", style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          ...List.generate(widget.order.items.length, (index) {
            return DishItem(widget.order.items[index]);
          }),
          SizedBox(height: 20),
          Text(
            "Paid By: ${widget.order.cardName}",
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
                  "Pick Up at: ${widget.order.pickUpTime}",
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
  final OrderItem dishItem;
  const DishItem(this.dishItem);

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
      child: Row(
        children: [
          Text(dishItem.foodName),
          Expanded(
            child: FlatButton.icon(
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
                                ...List.generate(dishItem.addOn.length,
                                    (index) {
                                  return Text(
                                      "${dishItem.addOn[index].name}: ${dishItem.addOn[index].quantity}",
                                      textAlign: TextAlign.center);
                                }),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              },
            ),
          ),
          Expanded(
            child: FlatButton.icon(
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
                                Text(dishItem.orderNote,
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              },
            ),
          ),
          Text("${dishItem.quantity}"),
          SizedBox(
            width: 20,
          ),
          Text("${dishItem.price}"),
        ],
      ),
    );
  }
}
