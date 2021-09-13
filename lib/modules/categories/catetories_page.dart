import 'dart:ui';

import 'package:restaurant/modules/dishes/Screen/addNewDish_page.dart';
import 'package:restaurant/modules/categories/provider/categories_provider.dart';
import 'package:restaurant/modules/dishes/Screen/dishes_page.dart';
import 'package:restaurant/modules/notifications/notification_page.dart';
import 'package:restaurant/modules/notifications/widget/NotificationAppBarWidget.dart';
import 'package:restaurant/responsive/functionsResponsive.dart';
import 'package:restaurant/themes/style.dart';
import 'package:restaurant/widgets/fancy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:restaurant/constants/assest_path.dart';
import 'package:restaurant/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:restaurant/modules/Authentication/providers/auth_provider.dart';

import 'models/categorie_model.dart';

class CatetoriesPage extends StatefulWidget {
  @override
  _CatetoriesPageState createState() => _CatetoriesPageState();
}

class _CatetoriesPageState extends State<CatetoriesPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          CatetoriesListPage.routeName: (context) => CatetoriesListPage(),
          DishPage.routeName: (context) => DishPage(
                ModalRoute.of(context).settings.arguments,
              ),
          NotificationPage.routeName: (context) => NotificationPage(),
          AddNewDish.routeName: (context) => AddNewDish(
                ModalRoute.of(context).settings.arguments,
              ),
        },
        theme: restaurantTheme,
        home: CatetoriesListPage());
  }
}

class CatetoriesListPage extends StatefulWidget {
  static final routeName = "categoryList";
  @override
  _CatetoriesListPageState createState() => _CatetoriesListPageState();
}

class _CatetoriesListPageState extends State<CatetoriesListPage> {
  TextEditingController newCategoryController = new TextEditingController();

  String error;
  bool first = true;
  final keyScaffold = GlobalKey<ScaffoldState>();

  final categoryForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, catProvider, child) {
      return Scaffold(
        key: keyScaffold,
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: showAppBarNodepad(context)
            ? AppBar(
                elevation: .2,
                title: Text("Manage Categories"),
                automaticallyImplyLeading: false,
                centerTitle: true,
                actions: [NotificationAppBarWidget()],
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // bottom:
              )
            : AppBar(
                elevation: .2,
                automaticallyImplyLeading: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text("Manage Categories"),
              ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Categories",
                        style: Theme.of(context).textTheme.headline5),
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
                          showDialog(
                            context: context,
                            builder: (context) {
                              bool addingCat = false;
                              return StatefulBuilder(
                                  builder: (context, snapshot) {
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: SimpleDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    title: Text("Add New Category",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 35, vertical: 25),
                                    children: [
                                      Form(
                                        key: categoryForm,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        child: TextFormField(
                                          // minLines: 6,
                                          validator: (vale) {
                                            print("vale $vale");
                                            if (vale == "") {
                                              return "please Inter name";
                                            }
                                          },
                                          // maxLines: 6,
                                          controller: newCategoryController,
                                          decoration: InputDecoration(
                                            hintText: "Category Name",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            contentPadding: EdgeInsets.only(
                                                left: 10, top: 15),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      addingCat == true
                                          ? Text("Adding...")
                                          : Container(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: RaisedButton(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          color: Theme.of(context).primaryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text("Save",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button),
                                          onPressed: () async {
                                            if (categoryForm.currentState
                                                .validate()) {
                                              setState(() {
                                                addingCat = true;
                                              });
                                              catProvider
                                                  .addNewCategory(
                                                await AuthProvider()
                                                    .resturantId(),
                                                newCategoryController.text,
                                              )
                                                  .then((value) {
                                                setState(() {
                                                  addingCat = false;
                                                });
                                                if (value['status'] == true) {
                                                  newCategoryController.text =
                                                      "";

                                                  Navigator.of(context).pop();
                                                } else {
                                                  // ScaffoldMessenger.of(
                                                  //         context)
                                                  //     .showSnackBar(
                                                  //         SnackBar(
                                                  //   content: const Text(
                                                  //       'Something went wrong!'),
                                                  //   duration:
                                                  //       const Duration(
                                                  //     seconds: 3,
                                                  //   ),
                                                  // ));
                                                }
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
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
            catProvider.getCategories == null
                ? FutureBuilder(
                    future: catProvider.fetchCategories(),
                    builder: (context, snapshot) {
                      return Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    })
                : catProvider.getCategories.length < 1
                    ? Expanded(
                        child: Center(
                          child: Text("The No Category"),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: catProvider.getCategories.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _categoryItemBuilder(
                              context,
                              catProvider.getCategories[index],
                              catProvider,
                            );
                          },
                        ),
                      )
          ],
        ),
      );
    });
  }

  _categoryItemBuilder(
      context, CategoryModel category, CategoryProvider catProvider) {
    TextEditingController editCatController = new TextEditingController();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category.categoryName,
                style: Theme.of(context).textTheme.headline6),
            Text("${category.foodNumber} Dishes",
                style: TextStyle(color: Colors.grey)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.room_service, color: AppColors.green),
                  onPressed: () {
                    Map pa = {
                      "catId": category.id,
                    };
                    Navigator.pushNamed(context, DishPage.routeName,
                            arguments: pa)
                        .then((value) {
                      Provider.of<CategoryProvider>(context, listen: false)
                          .setCategoryToNull();
                    });
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Image.asset(
                    "assets/images/editIcon.png",
                    height: 22,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        editCatController.text = category.categoryName;
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: SimpleDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text("Add/Edit Category",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 25),
                            children: [
                              Divider(),
                              TextFormField(
                                // initialValue: category.categoryName,
                                controller: editCatController,
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
                                    if (editCatController.text.length < 2) {
                                    } else if (editCatController.text.length >
                                        1) {
                                      print("Editing the category");
                                      catProvider
                                          .editCategory(category.id,
                                              editCatController.text)
                                          .then((re) {
                                        Navigator.of(context).pop();
                                        if (re['status'] == true) {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //   SnackBar(
                                          //       content: Text(
                                          //           "The Category Edited Successfully")),
                                          // );
                                        } else {}
                                      });
                                    } else {}
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Image.asset(
                    "assets/images/delete.png",
                    height: 22,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => FancyDialog(
                              title: "Delete Category!",
                              okFun: () {
                                catProvider
                                    .deleteCategoy(category.id)
                                    .then((res) {
                                  if (res['status']) {
                                    keyScaffold.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "The Category Deleted Successfully"),
                                    ));
                                  } else {
                                    keyScaffold.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(res['message']),
                                    ));
                                  }
                                });
                              },
                              cancelFun: () {},
                              descreption: "Are You Sure To Delete Category?",
                            ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
