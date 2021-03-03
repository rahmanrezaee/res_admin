//core
import 'package:flutter/material.dart';

//packages
import 'package:responsive_grid/responsive_grid.dart';
import 'package:restaurant/modules/addNewDish/addNewDish_page.dart';
import 'package:restaurant/providers/navigator_provider.dart';

import '../../themes/style.dart';

class DishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      AddNewDish.routeName: (context) => AddNewDish(),
    }, theme: restaurantTheme, home: DishHome());
  }
}

class DishHome extends StatefulWidget {
  @override
  _DishHomeState createState() => _DishHomeState();
}

class _DishHomeState extends State<DishHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Manage Doshes"),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewDish.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ResponsiveGridRow(
            children: [
              ...List.generate(10, (i) {
                return ResponsiveGridCol(
                  xs: 6,
                  sm: 6,
                  md: 4,
                  lg: 3,
                  child: DishItem(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class DishItem extends StatefulWidget {
  @override
  _DishItemState createState() => _DishItemState();
}

class _DishItemState extends State<DishItem> {
  int visible = 0;
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(DishDetails.routeName);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 150,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor,
                        ]),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=700%2C636',
                      fit: BoxFit.cover,
                      color: visible == 0 ? Colors.transparent : Colors.white54,
                      colorBlendMode: BlendMode.lighten,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        visible == 0 ? visible = 1 : visible = 0;
                      });
                    },
                    child: Icon(
                      visible == 0
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child:
                      Icon(Icons.star, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Food for eat Food for eat Food for eat Food for eat Food for eat Food for eat ",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "100\$",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 35,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          quantity = quantity - 1;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 5),
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
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ]),
            ]),
          )
        ]),
      ),
    );
  }
}
