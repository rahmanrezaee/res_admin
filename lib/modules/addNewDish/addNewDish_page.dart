//Core
import 'package:flutter/material.dart';
//packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaurant/themes/colors.dart';

class AddNewDish extends StatefulWidget {
  static String routeName = "AddNewDish";
  @override
  _AddNewDishState createState() => _AddNewDishState();
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class _AddNewDishState extends State<AddNewDish> {
  int _current = 0;
  bool favorited = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Scaffold(
        appBar: AppBar(
          elevation: .2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ), //When Editing a dish title should be the dish name
          title: Text("Add New Dish / Dish Name"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 346.0,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                      autoPlay: true,
                    ),
                    items: imgList.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            // margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              image: DecorationImage(
                                image: NetworkImage(i),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {}),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white60,
                          ),
                          child: IconButton(
                              icon: Icon(Icons.add, color: Colors.white),
                              onPressed: () {}),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgList.map((url) {
                        int index = imgList.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Color.fromRGBO(255, 255, 255, 0.9)
                                : Color.fromRGBO(255, 255, 255, 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _textFieldBuilder("Dish Name"),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _textFieldBuilder("Price"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                minLines: 5,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.only(left: 10, top: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Preparation Time",
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(width: 50),
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("HH : MM",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal)),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Addon:",
                          style: Theme.of(context).textTheme.headline3),
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: RaisedButton(
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          onPressed: () {},
                          color: Theme.of(context).primaryColor,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Container(
                  width: 100,
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline_outlined,
                          color: AppColors.green),
                      Text("Extra Cheese",
                          style: Theme.of(context).textTheme.headline4),
                    ],
                  ),
                ),
                trailing: Text("Price: 200"),
              ),
              // _extraCheeseBuilder(context),
              // SizedBox(height: 10),
              // _extraCheeseBuilder(context),
            ],
          ),
        ),
      ),
    );
  }
}

_textFieldBuilder(String hintText) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.only(left: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
  );
}

_extraCheeseBuilder(context) {
  return ListTile(
    leading: Row(
      children: [
        Icon(Icons.add_circle_outline_outlined, color: AppColors.green),
        Text("Extra Cheese", style: Theme.of(context).textTheme.headline4),
      ],
    ),
    trailing: Row(children: [
      Text("Price: 200"),
    ]),
  );
}
