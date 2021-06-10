
import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:azaFashions/models/Listing/Filters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Single extends StatefulWidget {
  List<FilterItems> items;
  static List<FilterModel> selectedItems=List<FilterModel>();
  String id;
  static String radioItem = "";
  Single({this.items,this.id});

  @override
  _SingleState createState() => _SingleState();
}

class _SingleState extends State<Single> {
  /*List<DemoClass> demo= [];*/


  // Group Value for Radio Button.
  int id = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        child:  Column(children: <Widget>[
          ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: RadioListTile(
                    title: Text(
                      widget.items[index].name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          fontFamily: "Helvetica",
                          color: Colors.black),
                    ),
                    activeColor: Colors.black,
                    groupValue: Single.radioItem,
                    value: widget.items[index].name,
                    onChanged: (val) {
                      setState(() {
                        Single.radioItem=val;
                        widget.items[index].selected=!widget.items[index].selected;
                        Single.selectedItems.add(FilterModel(widget.id,widget.items[index].value));
                      });
                      updateTheData();
                    }),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ]),
      ),
    );
  }

  void updateTheData() {
    setState(() {
      if(Single.selectedItems!=null && Single.selectedItems.length>0){
        setState(() {
          final index =  MyFilter.filterModel.indexWhere((element) => element.parent_id == Single.selectedItems.first.parent_id);
          print("INDEX VALUE: $index");
          if(index!=-1 ){
            MyFilter.filterModel[index].selectedValue= Single.selectedItems[0].selectedValue;
          }
          else{
            MyFilter.filterModel.addAll(Single.selectedItems);
          }
        });
        Single.selectedItems.clear();
      }

    });
  }
}
