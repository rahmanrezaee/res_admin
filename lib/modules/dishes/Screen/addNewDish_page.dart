//Core
import 'dart:async';
import 'dart:ui';

import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/Services/UploadFile.dart';
import 'package:restaurant/constants/UrlConstants.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';
import 'package:restaurant/modules/dishes/DishServics/dishServices.dart';
import 'package:restaurant/modules/dishes/Models/AddonModel.dart';
import 'package:restaurant/modules/dishes/Models/ImageModel.dart';
import 'package:restaurant/modules/dishes/Models/dishModels.dart';
import 'package:restaurant/modules/dishes/Models/review_model.dart';
import 'package:restaurant/modules/dishes/Screen/dishes_page.dart';
import 'package:restaurant/modules/report/widget/TextfieldResturant.dart';
import 'package:flutter/material.dart';
//packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaurant/themes/colors.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
//widgets

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
  bool _isSubmit = false;

  final addonForm = GlobalKey<FormState>();

  TimeOfDay selectedTime = TimeOfDay.now();

  DishModel dishModel = DishModel();
  // List<AddonModel> list = [];
  String dishId;
  String catId;
  List<ReviewModel> getReview = [];
  AuthProvider authProvider;
  @override
  void initState() {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    dishModel.preparationTime = "00:00";
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

      getSingleDish(dishId, authProvider).then((value) {
        setState(() {
          dishModel = value['dish'];
          getReview = value['review'];
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
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), //When Editing a dish title should be the dish name
        title: Text("${this.dishId != null ? "Edit Dish" : "Add Dish"}"),
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
        bottom: _isLoading
            ? PreferredSize(
                preferredSize: Size(10, 10),
                child: LinearProgressIndicator(),
              )
            : null,
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
                                          Icon(Icons.add, color: Colors.black),
                                      onPressed: () {
                                        openImagePickerModal(context)
                                            .then((value) async {
                                          if (value != null) {
                                            setState(() {
                                              _isUploadingImage = true;
                                              _isLoading = true;
                                            });
                                            await uploadFile(
                                                    value,
                                                    "profile-photo",
                                                    authProvider.token)
                                                .then((value) => imgList.add(
                                                    ImageModel.toJson(value)));

                                            setState(() {
                                              _isUploadingImage = false;
                                              _isLoading = false;
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
                      isSubmiting == true && imgList.isEmpty
                          ? Container(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Please Add at least a Image",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : Container(),
                      SizedBox(height: 15),
                      ResponsiveGridRow(children: [
                        ResponsiveGridCol(
                          lg: 6,
                          md: 6,
                          sm: 12,
                          xl: 12,
                          xs: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                        ),
                        ResponsiveGridCol(
                          lg: 6,
                          md: 6,
                          sm: 12,
                          xl: 12,
                          xs: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormFieldResturant(
                              initValue: "${dishModel.price ?? ""}",
                              typetext: TextInputType.numberWithOptions(
                                  decimal: true),
                              hintText: "Price",
                              perfixText: "\$",
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
                        )
                      ]),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormFieldResturant(
                          initValue: "${dishModel.tax ?? ""}",
                          typetext:
                              TextInputType.numberWithOptions(decimal: true),
                          hintText: "Tax",
                          onChange: (value) {
                            setState(() {
                              dishModel.tax = double.parse(value);
                            });
                          },
                          valide: (String value) {
                            if (value.isEmpty) {
                              return "Your tax  is Empty";
                            }
                          },
                          onSave: (value) {
                            setState(() {
                              dishModel.tax = double.parse(value);
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
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
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
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
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Preparation Time",
                                style: Theme.of(context).textTheme.headline3),
                            SizedBox(width: 50),
                            OutlineButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {
                                _selectTime(context)
                                    .then((value) => setState(() {
                                          dishModel.preparationTime = value;
                                        }));
                              },
                              child: Text(
                                "${dishModel.preparationTime ?? "00:00"}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _isSubmit == true && dishModel.preparationTime == null ||
                              dishModel.preparationTime == ""
                          ? Container(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Please select Preparation Time",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : Container(),
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
                                  onPressed: () {
                                    AddonItems addonModel = new AddonItems();

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20, horizontal: 20),
                                              width: 450,
                                              height: 310,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              // alignment: Alignment.center,
                                              child: Form(
                                                key: addonForm,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        child: Text(
                                                          "New Add On",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4,
                                                        ),
                                                      ),
                                                      Divider(),
                                                      SizedBox(height: 15),
                                                      ResponsiveGridRow(
                                                        children: [
                                                          ResponsiveGridCol(
                                                            lg: 6,
                                                            md: 6,
                                                            sm: 12,
                                                            xl: 12,
                                                            xs: 12,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  TextFormFieldResturant(
                                                                hintText:
                                                                    "Add On Name",
                                                                onChange:
                                                                    (value) {
                                                                  setState(() {
                                                                    addonModel
                                                                            .name =
                                                                        value;
                                                                  });
                                                                },
                                                                valide: (String
                                                                    value) {
                                                                  if (value
                                                                      .isEmpty) {
                                                                    return "Your Dish  Name is Empty";
                                                                  }
                                                                },
                                                                onSave:
                                                                    (value) {
                                                                  setState(() {
                                                                    addonModel
                                                                            .name =
                                                                        value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          ResponsiveGridCol(
                                                            lg: 6,
                                                            md: 6,
                                                            sm: 12,
                                                            xl: 12,
                                                            xs: 12,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  TextFormFieldResturant(
                                                                hintText:
                                                                    "Add On Price",
                                                                perfixText:
                                                                    "\$",
                                                                typetext: TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                                onChange:
                                                                    (value) {
                                                                  setState(() {
                                                                    addonModel
                                                                            .price =
                                                                        double.parse(
                                                                            value);
                                                                  });
                                                                },
                                                                valide: (String
                                                                    value) {
                                                                  if (value
                                                                      .isEmpty) {
                                                                    return "Your Add On Price is Empty";
                                                                  }
                                                                },
                                                                onSave:
                                                                    (value) {
                                                                  setState(() {
                                                                    addonModel
                                                                            .price =
                                                                        double.parse(
                                                                            value);
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 15),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: RaisedButton(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          elevation: 0,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Text(
                                                            "Save",
                                                            style: Theme.of(
                                                                    context)
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Reviews",
                                style: Theme.of(context).textTheme.headline3),
                          ],
                        ),
                      ),
                      getReview.length == 0
                          ? Card(
                              child: SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text("No Review"),
                                ),
                              ),
                            )
                          : ResponsiveGridRow(
                              children: [
                                ...List.generate(getReview.length, (i) {
                                  return ResponsiveGridCol(
                                    xs: 12,
                                    sm: 12,
                                    md: 12,
                                    lg: 6,
                                    xl: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CommentItemDish(
                                        getReview[i],
                                      ),
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

  bool isSubmiting = false;
  addDish() {
    setState(() {
      isSubmiting = true;
    });
    if (_formKey.currentState.validate() && imgList.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _isSubmit = true;
      });
      dishModel.images = imgList;
      dishModel.categoryId = catId;
      if (dishId != null) {
        editDishService(dishModel.sendMap(), dishId, authProvider)
            .then((result) {
          setState(() {
            _isLoading = false;
          });

          if (result['status'] == true) {
            print("Mahdi: Executed 2");
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Successfuly Updated."),
              duration: Duration(seconds: 3),
            ));
            Timer(Duration(seconds: 3), () {
              Map pa = {
                "catId": dishModel.categoryId,
              };
              Navigator.pushReplacementNamed(
                context,
                DishPage.routeName,
                arguments: pa,
              );
            });
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("${result['message']}"),
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
        addDishService(dishModel.sendMap(), authProvider).then((result) {
          setState(() {
            _isLoading = false;
          });

          if (result['status'] == true) {
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
              content: Text("${result['message']}"),
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
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white60,
                  ),
                  child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          imgList.remove(element);
                        });
                      }),
                ),
              ),
            ],
          );
        },
      ));
    });

    return item;
  }
}

class CommentItemDish extends StatelessWidget {
  final ReviewModel review;

  CommentItemDish(
    this.review,
  );
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FadeInImage.assetNetwork(
                    image: "${review.userId.avatar}",
                    placeholder: "",
                  ),
                ),
                title: Text(
                  "${review.userId.username}",
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${Jiffy(review.date).yMEd}"),
                    SizedBox(height: 5),
                    SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {},
                      starCount: review.rate.toInt(),
                      rating: 4,
                      size: 20.0,
                      isReadOnly: true,
                      color: Theme.of(context).primaryColor,
                      borderColor: Theme.of(context).primaryColor,
                      spacing: 0.0,
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${review.message}",
                      style: TextStyle(height: 1.3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

// ignore: unused_element
_textFieldBuilder(String hintText) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
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
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
  );
}
