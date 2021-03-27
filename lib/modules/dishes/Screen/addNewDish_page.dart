//Core
import 'dart:async';

import 'package:restaurant/Services/UploadFile.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/customers/models/review_model.dart';
import 'package:restaurant/modules/dishes/DishServics/dishServices.dart';
import 'package:restaurant/modules/dishes/Models/AddonModel.dart';
import 'package:restaurant/modules/dishes/Models/ImageModel.dart';
import 'package:restaurant/modules/dishes/Models/dishModels.dart';
import 'package:restaurant/modules/dishes/Screen/dishes_page.dart';
import 'package:restaurant/modules/report/widget/TextfieldResturant.dart';
import 'package:flutter/material.dart';
//packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaurant/themes/colors.dart';
import 'package:responsive_grid/responsive_grid.dart';
//widgets
import 'package:restaurant/widgets/commentItem_widget.dart';

class AddNewDish extends StatefulWidget {
  Map params;
  AddNewDish(this.params);
  static String routeName = "AddNewDish";
  @override
  _AddNewDishState createState() => _AddNewDishState();
}

class _AddNewDishState extends State<AddNewDish> {
  List<ImageModel> imgList = [];

  int _current = 0;
  bool favorited = false;
  bool _isUpdateDish = false;
  bool _isUploadingImage = false;
  bool _autoValidateAddon = false;

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autoValidate = false;
  bool _isLoading = false;

  final addonForm = GlobalKey<FormState>();

  TimeOfDay selectedTime = TimeOfDay.now();

  DishModel dishModel = DishModel();
  // List<AddonModel> list = [];
  String dishId;
  String catId;

  @override
  void initState() {
    dishId = widget.params['dishId'];
    catId = widget.params['catId'];

    AuthProvider().resturantId().then((value) {
      setState(() {
        dishModel.restaurantId = value;
      });
    });

    if (dishId != null) {
      setState(() {
        _isUpdateDish = true;
      });

      getSingleDish(dishId).then((value) {
        setState(() {
          dishModel = value;
          imgList = dishModel.images;
          _isUpdateDish = false;
        });
      });
    }
  }

  Future<String> _selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: const Color(0xFF504d4d),
                accentColor: const Color(0xFF504d4d),
                colorScheme:
                    ColorScheme.light(primary: const Color(0xFF504d4d)),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child,
              ));
        });

    if (picked_s != null) return "${picked_s.hour}:${picked_s.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: .2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), //When Editing a dish title should be the dish name
        title: Text("${this.dishId != null ? "Edit Dish" : "Add New Dish"}"),
        actions: [
          Container(
            width: 100,
            child: IconButton(
                icon: Row(
                  children: [
                    Text(dishId != null ? "Update" : "Save",
                        style: TextStyle(fontSize: 18)),
                    Icon(
                      Icons.save,
                    ),
                  ],
                ),
                onPressed: () {
                  addDish();
                }),
          ),
        ],
      ),
      body: !_isUpdateDish
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            color: Colors.grey,
                            child: CarouselSlider(
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
                              items: getGallaryImageBuilder(imgList),
                            ),
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
                                      icon:
                                          Icon(Icons.add, color: Colors.white),
                                      onPressed: () {
                                        openImagePickerModal(context)
                                            .then((value) async {
                                          if (value != null) {
                                            setState(() {
                                              _isUploadingImage = true;
                                            });
                                            await uploadFile(
                                                    value,
                                                    "profile-photo",
                                                    await AuthProvider().token)
                                                .then((value) => imgList.add(
                                                    ImageModel.toJson(value)));

                                            setState(() {
                                              _isUploadingImage = false;
                                            });
                                          }
                                        });
                                      }),
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
                              child: TextFormFieldResturant(
                                initValue: dishModel.foodName,
                                hintText: "Dish Name",
                                onChange: (value) {
                                  setState(() {
                                    dishModel.foodName = value;
                                  });
                                },
                                valide: (String value) {
                                  if (value.isEmpty) {
                                    return "Your Dish  Name is Empty";
                                  }
                                },
                                onSave: (value) {
                                  setState(() {
                                    dishModel.foodName = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormFieldResturant(
                                initValue: "${dishModel.price ?? ""}",
                                typetext: TextInputType.number,
                                hintText: "Price",
                                onChange: (value) {
                                  setState(() {
                                    dishModel.price = double.parse(value);
                                  });
                                },
                                valide: (String value) {
                                  if (value.isEmpty) {
                                    return "Your Price  is Empty";
                                  }
                                },
                                onSave: (value) {
                                  setState(() {
                                    dishModel.price = double.parse(value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: dishModel.description,
                        minLines: 5,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: "Description",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.only(left: 10, top: 20),
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
                        onChanged: (value) {
                          setState(() {
                            dishModel.description = value;
                          });
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Your description  is Empty";
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            dishModel.description = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Preparation Time",
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(width: 50),
                          OutlineButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () {
                              _selectTime(context).then((value) => setState(() {
                                    dishModel.preparationTime = value;
                                  }));
                            },
                            child: Text(
                              "${dishModel.preparationTime ?? "00:00"}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            ),
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
                                  style: Theme.of(context).textTheme.headline6),
                              SizedBox(
                                width: 35,
                                height: 35,
                                child: RaisedButton(
                                  padding: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  onPressed: () {
                                    AddonItems addonModel = new AddonItems();

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 40),
                                            width: 400,
                                            height: 280,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            // alignment: Alignment.center,
                                            child: Form(
                                              key: addonForm,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: Text(
                                                      "New Add On",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    ),
                                                  ),
                                                  Divider(),
                                                  SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            TextFormFieldResturant(
                                                          hintText:
                                                              "Add On Name",
                                                          onChange: (value) {
                                                            setState(() {
                                                              addonModel.name =
                                                                  value;
                                                            });
                                                          },
                                                          valide:
                                                              (String value) {
                                                            if (value.isEmpty) {
                                                              return "Your Dish  Name is Empty";
                                                            }
                                                          },
                                                          onSave: (value) {
                                                            setState(() {
                                                              addonModel.name =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Container(
                                                        width: 140,
                                                        child:
                                                            TextFormFieldResturant(
                                                          hintText:
                                                              "Add On Price",
                                                          typetext:
                                                              TextInputType
                                                                  .number,
                                                          onChange: (value) {
                                                            setState(() {
                                                              addonModel.price =
                                                                  double.parse(
                                                                      value);
                                                            });
                                                          },
                                                          valide:
                                                              (String value) {
                                                            if (value.isEmpty) {
                                                              return "Your Add On Price is Empty";
                                                            }
                                                          },
                                                          onSave: (value) {
                                                            setState(() {
                                                              addonModel.price =
                                                                  double.parse(
                                                                      value);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 15),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: RaisedButton(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Text(
                                                        "Save",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .button,
                                                      ),
                                                      onPressed: () {
                                                        if (addonForm
                                                            .currentState
                                                            .validate()) {
                                                          setState(() {
                                                            dishModel
                                                                .addOnDishAdmin
                                                                .add(
                                                                    addonModel);
                                                          });

                                                          Navigator.pop(
                                                              context);
                                                        } else {
                                                          setState(() {
                                                            _autoValidateAddon =
                                                                true;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  color: Theme.of(context).primaryColor,
                                  child: Icon(Icons.add, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            ListView.builder(
                                itemCount: dishModel.addOnDishAdmin.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    dishModel.addOnDishAdmin
                                                        .removeAt(index);
                                                  });
                                                },
                                                icon: Icon(Icons.close,
                                                    color: AppColors.redText)),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                                    "${dishModel.addOnDishAdmin[index].name}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6)),
                                            Text(
                                                "Price: ${dishModel.addOnDishAdmin[index].price}"),
                                          ],
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                      ResponsiveGridRow(
                        children: [
                          ...List.generate(2, (i) {
                            return ResponsiveGridCol(
                              xs: 12,
                              sm: 12,
                              md: 12,
                              lg: 6,
                              xl: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                // child: Visibility(
                                //     visible: dishId != null,
                                //     child: CommentItem(new ReviewModel())),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  addDish() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      dishModel.images = imgList;
      dishModel.categoryId = catId;
      if (dishId != null) {
        editDishService(dishModel.sendMap(), dishId).then((result) {
          setState(() {
            _isLoading = false;
          });

          if (result == true) {
            print("Mahdi: Executed 2");
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Successfuly Updated."),
              duration: Duration(seconds: 3),
            ));
            Timer(Duration(seconds: 3), () {
              Map pa = {
                "catId": dishModel.categoryId,
              };

              Navigator.pushReplacementNamed(context, DishPage.routeName,
                  arguments: pa);
            });
          } else {
            print("Mahdi: Executed 3");

            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Something went wrong!! Please try again later."),
              duration: Duration(seconds: 4),
            ));
          }

          print("Mahdi: Executed 4");
        }).catchError((error) {
          print("Mahdi Error: $error");
          setState(() {
            _isLoading = false;
          });
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Something went wrong!! Please try again later."),
            duration: Duration(seconds: 4),
          ));
        });
      } else {
        addDishService(dishModel.sendMap()).then((result) {
          setState(() {
            _isLoading = false;
          });

          if (result == true) {
            print("Mahdi: Executed 2");
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Successfuly added."),
              duration: Duration(seconds: 3),
            ));
            Timer(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
          } else {
            print("Mahdi: Executed 3");

            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Something went wrong!! Please try again later."),
              duration: Duration(seconds: 4),
            ));
          }

          print("Mahdi: Executed 4");
        }).catchError((error) {
          print("Mahdi Error: $error");
          setState(() {
            _isLoading = false;
          });
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Something went wrong!! Please try again later."),
            duration: Duration(seconds: 4),
          ));
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  List<Widget> getGallaryImageBuilder(List<ImageModel> imgList) {
    List<Widget> item = [];

    imgList.forEach((element) {
      item.add(Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                // margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  image: DecorationImage(
                    image: NetworkImage(element.url),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        imgList.remove(element);
                      });
                    }),
              ),
            ],
          );
        },
      ));
    });

    return item;
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
