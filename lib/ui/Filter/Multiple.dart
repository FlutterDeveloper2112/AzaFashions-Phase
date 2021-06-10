import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/ui/CatalogueDetails/Catlogue.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:azaFashions/models/Listing/Filters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Multiple extends StatefulWidget {
  List<FilterItems> items;
  String name;
  bool nested;
  String id;
  List<FilterTitle> titleItems;
  bool isClear;
  List<FilterTitle> duplicateTitleItems;
  bool search = false;
  String oldName;

  static int counter=0;
  Multiple(
      {this.items,
        this.nested,
        this.id,
        this.titleItems,
        this.name,
        this.isClear});

  static List<FilterModel> selectedItems = List<FilterModel>();
  static String removetag = "";

  @override
  _MultipleState createState() => _MultipleState();
}

class _MultipleState extends State<Multiple> {
  TextEditingController searchController = new TextEditingController();
  List<FilterItems> searchData = [];
  List<FilterTitle> searchTitleData = [];
  List<String> selectedSubItem =[];
  String filter;

  @override
  void initState() {
    setState(() {
      widget.search = false;
      widget.oldName = widget.name;
      print("CATALOGUE SCREEN VISIT: ${Catalogue.screenVisit}");
      if(Catalogue.screenVisit==0){
        print("ITEMS ${widget.items.length}");
        if( widget.items.length==0){
          print("EXECUTED INIT State");
          setState(() {
            widget.titleItems.forEach((element) {
              element.list.forEach((elem) {
                if (elem.selected) {
                  setState(() {
                    element.selected = true;
                  });
                  Multiple.removetag = "";
                  if (Multiple.selectedItems.length > 0 && Multiple.selectedItems != null) {
                    for (int i = 0;
                    i < Multiple.selectedItems.length;
                    i++) {
                      if (Multiple.selectedItems[i]
                          .parent_id ==
                          widget.id) {
                        Multiple.selectedItems[i]
                            .selectedValue = Multiple
                            .selectedItems[i]
                            .selectedValue
                            .trimRight() +
                            "," +
                            elem.value;
                      }
                    }
                  }
                  else {
                    Multiple.selectedItems.add(
                        FilterModel(widget.id,
                            elem.value));
                  }
                  updateTheData();
                  elem.subItems.forEach((ele) {
                    setState(() {
                      if (ele.selected) {
                        Multiple.removetag = "";
                        if (Multiple.selectedItems != null && Multiple.selectedItems.length > 0 ) {
                          for (int forIndex = 0; forIndex < Multiple.selectedItems.length; forIndex++) {
                            if (Multiple
                                .selectedItems[
                            forIndex]
                                .parent_id ==
                                elem.field) {
                              Multiple.selectedItems[forIndex].selectedValue = Multiple.selectedItems[forIndex].selectedValue
                                  .trimRight() +
                                  "," + ele
                                  .value;
                            }
                          }
                        } else {
                          Multiple.selectedItems
                              .add(FilterModel(
                              elem
                                  .field,
                              ele
                                  .value));
                        }
                      }
                    });
                    updateTheData();
                  });
                }
                updateTheData();
              });
            });
          });
        }
        else{
          widget.items.forEach((element) {
            if (element.selected) {
              Multiple.removetag = "";
              if (Multiple.selectedItems.length > 0 &&
                  Multiple.selectedItems != null) {
                for (int i = 0;
                i < Multiple.selectedItems.length;
                i++) {
                  if (Multiple.selectedItems[i]
                      .parent_id ==
                      widget.id) {
                    Multiple.selectedItems[i]
                        .selectedValue = Multiple
                        .selectedItems[i]
                        .selectedValue
                        .trimRight() +
                        "," +
                        element.value;
                  }
                }
              } else {
                Multiple.selectedItems.add(
                    FilterModel(widget.id,
                        element.value));
              }
              updateTheData();
              element.subItems.forEach((elem) {
                setState(() {
                  if (elem.selected) {
                    Multiple.removetag = "";
                    if (Multiple.selectedItems != null && Multiple.selectedItems.length > 0 ) {
                      for (int forIndex = 0; forIndex < Multiple.selectedItems.length; forIndex++) {
                        if (Multiple
                            .selectedItems[
                        forIndex]
                            .parent_id ==
                            elem.field) {
                          Multiple.selectedItems[forIndex].selectedValue = Multiple.selectedItems[forIndex].selectedValue
                              .trimRight() +
                              "," + elem
                              .value;
                        }
                      }
                    } else {
                      Multiple.selectedItems
                          .add(FilterModel(
                          element
                              .field,
                          elem
                              .value));
                    }
                  }
                });
                updateTheData();
              });
            }
            updateTheData();
          });
        }
      }
     /* if(Catalogue.screenVisit==0){
        widget.items.forEach((element) {
          if (element.selected) {
            Multiple.removetag = "";
            if (Multiple.selectedItems.length > 0 &&
                Multiple.selectedItems != null) {
              for (int i = 0;
              i < Multiple.selectedItems.length;
              i++) {
                if (Multiple.selectedItems[i]
                    .parent_id ==
                    widget.id) {
                  Multiple.selectedItems[i]
                      .selectedValue = Multiple
                      .selectedItems[i]
                      .selectedValue
                      .trimRight() +
                      "," +
                      element.value;
                }
              }
            } else {
              Multiple.selectedItems.add(
                  FilterModel(widget.id,
                      element.value));
            }
            updateTheData();
            element.subItems.forEach((elem) {
              setState(() {
                if (elem.selected) {
                  Multiple.removetag = "";
                  if (Multiple.selectedItems != null && Multiple.selectedItems.length > 0 ) {
                    for (int forIndex = 0; forIndex < Multiple.selectedItems.length; forIndex++) {
                      if (Multiple
                          .selectedItems[
                      forIndex]
                          .parent_id ==
                          elem.field) {
                        Multiple.selectedItems[forIndex].selectedValue = Multiple.selectedItems[forIndex].selectedValue
                            .trimRight() +
                            "," + elem
                            .value;
                      }
                    }
                  } else {

                    Multiple.selectedItems
                        .add(FilterModel(
                        element
                            .field,
                        elem
                            .value));
                  }
                }

              });
              updateTheData();
            });
          }
          updateTheData();
        });
      }*/



    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Multiple oldWidget) {
    if (widget.name != widget.oldName) {
      searchData = [];
      searchTitleData = [];
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {



    if (searchData.isEmpty) {
      searchData=(widget.items);
    }

    if (searchTitleData.isEmpty) {
      searchTitleData=(widget.titleItems);
    }

    if (widget.isClear) {
      searchTitleData.forEach((element) {
        setState(() {
          element.list.forEach((element) {
            element.selected = false;
            element.subItems.forEach((element) {
              element.selected = false;
            });
          });
        });
      });
      searchData.forEach((element) {
        setState(() {
          element.selected = false;
        });
      });

      setState(() {
        widget.isClear = false;
      });
    }

    return Expanded(
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          searchBox("Search for ${widget.name}"),
          if (widget.titleItems.isNotEmpty && !widget.search) withTitle(),

          if(widget.items.isNotEmpty)
            Padding(
                padding: EdgeInsets.only(top: 50, bottom: 60),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: searchData.length,
                    itemBuilder: (BuildContext context, int index) {
                      if ( filter == null || filter == "") {
                        return ListTile(
                          title: Column(
                            children: [
                              CheckboxListTile(
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                  title: Text(
                                    searchData[index].name,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        fontFamily: "Helvetica",
                                        color: Colors.black),
                                  ),
                                  activeColor: Colors.black,
                                  checkColor: Colors.white,
                                  value: searchData[index].selected,
                                  onChanged: (bool val) {
                                    setState(() {
                                      searchData[index].selected =
                                      !searchData[index].selected;
                                      if (searchData[index].selected) {
                                        MyFilter.modified = "modified";
                                        Multiple.removetag = "";
                                        if (Multiple.selectedItems.length > 0 &&
                                            Multiple.selectedItems != null) {
                                          for (int i = 0;
                                          i < Multiple.selectedItems.length;
                                          i++) {
                                            if (Multiple.selectedItems[i]
                                                .parent_id ==
                                                widget.id) {
                                              Multiple.selectedItems[i]
                                                  .selectedValue = Multiple
                                                  .selectedItems[i]
                                                  .selectedValue
                                                  .trimRight() +
                                                  "," +
                                                  searchData[index].value;
                                            }
                                          }
                                        } else {
                                          Multiple.selectedItems.add(
                                              FilterModel(widget.id,
                                                  searchData[index].value));
                                        }
                                        updateTheData();

                                        searchData[index]
                                            .subItems
                                            .forEach((element) {
                                          setState(() {
                                            element.selected = true;
                                            print(element.value);
                                            Multiple.removetag = "";
                                            if (Multiple.selectedItems !=
                                                null &&
                                                Multiple.selectedItems.length >
                                                    0) {
                                              for (int forIndex = 0;
                                              forIndex <
                                                  Multiple
                                                      .selectedItems.length;
                                              forIndex++) {
                                                if (Multiple
                                                    .selectedItems[forIndex]
                                                    .parent_id ==
                                                    searchData[index].field) {
                                                  Multiple
                                                      .selectedItems[forIndex]
                                                      .selectedValue = Multiple
                                                      .selectedItems[
                                                  forIndex]
                                                      .selectedValue
                                                      .trimRight() +
                                                      "," +
                                                      element.value;
                                                }
                                              }
                                            } else {
                                              Multiple.selectedItems.add(
                                                  FilterModel(
                                                      searchData[index].field,
                                                      element.value));
                                            }
                                          });
                                          updateTheData();
                                        });
                                      } else {
                                        MyFilter.modified = "modified";
                                        searchData[index]
                                            .subItems
                                            .forEach((element) {
                                          if (element.selected == true) {
                                            element.selected = false;
                                            selectedSubItem.add(element.value);
                                          }
                                        });

                                        /* searchData[index]
                                        .subItems
                                        .forEach((element) {
                                      element.selected = false;
                                    });*/
                                        Multiple.removetag = "remove";
                                        if (Multiple.selectedItems.length > 0 &&
                                            Multiple.selectedItems != null) {
                                          for (int i = 0;
                                          i < Multiple.selectedItems.length;
                                          i++) {
                                            if (Multiple.selectedItems[i]
                                                .parent_id ==
                                                widget.id) {
                                              Multiple.selectedItems[i]
                                                  .selectedValue = Multiple
                                                  .selectedItems[i]
                                                  .selectedValue
                                                  .trimRight() +
                                                  "," +
                                                  searchData[index].value;
                                            }
                                          }
                                        } else {
                                          MyFilter.modified = "modified";
                                          Multiple.selectedItems.add(
                                              FilterModel(widget.id,
                                                  searchData[index].value));
                                        }
                                        updateTheData();
                                      }
                                    });
                                    // updateTheData();
                                  }),
                              if (searchData[index].subItems.isNotEmpty)
                                if (searchData[index].selected)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 26),
                                    child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, int i) {
                                          return CheckboxListTile(
                                              contentPadding:
                                              EdgeInsets.only(left: 5),
                                              title: Text(
                                                searchData[index]
                                                    .subItems[i]
                                                    .name,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontSize: 13.5,
                                                    fontFamily: "Helvetica",
                                                    color: Colors.black),
                                                softWrap: true,
                                              ),
                                              controlAffinity:
                                              ListTileControlAffinity
                                                  .leading,
                                              activeColor: Colors.white,
                                              checkColor: Colors.black,
                                              value: searchData[index]
                                                  .subItems[i]
                                                  .selected,
                                              onChanged: (bool val) {
                                                setState(() {
                                                  searchData[index]
                                                      .subItems[i]
                                                      .selected =
                                                  !searchData[index]
                                                      .subItems[i]
                                                      .selected;
                                                  print(searchData[index]
                                                      .subItems[i]
                                                      .value);
                                                  print(
                                                      searchData[index].field);
                                                  if (searchData[index]
                                                      .subItems[i]
                                                      .selected ==
                                                      true) {
                                                    MyFilter.modified =
                                                    "modified";
                                                    Multiple.removetag = "";
                                                    if (Multiple.selectedItems !=
                                                        null &&
                                                        Multiple.selectedItems
                                                            .length >
                                                            0) {
                                                      for (int forIndex = 0;
                                                      forIndex <
                                                          Multiple
                                                              .selectedItems
                                                              .length;
                                                      forIndex++) {
                                                        if (Multiple
                                                            .selectedItems[
                                                        forIndex]
                                                            .parent_id ==
                                                            searchData[index]
                                                                .field) {
                                                          Multiple
                                                              .selectedItems[
                                                          forIndex]
                                                              .selectedValue = Multiple
                                                              .selectedItems[
                                                          forIndex]
                                                              .selectedValue
                                                              .trimRight() +
                                                              "," +
                                                              searchData[index]
                                                                  .subItems[i]
                                                                  .value;
                                                        }
                                                      }
                                                    } else {
                                                      Multiple.selectedItems
                                                          .add(FilterModel(
                                                          searchData[index]
                                                              .field,
                                                          searchData[index]
                                                              .subItems[i]
                                                              .value));
                                                    }
                                                  } else {
                                                    MyFilter.modified =
                                                    "modified";
                                                    Multiple.removetag =
                                                    "remove";
                                                    if (Multiple.selectedItems
                                                        .length >
                                                        0 &&
                                                        Multiple.selectedItems !=
                                                            null) {
                                                      for (int i = 0;
                                                      i <
                                                          Multiple
                                                              .selectedItems
                                                              .length;
                                                      i++) {
                                                        if (Multiple
                                                            .selectedItems[
                                                        i]
                                                            .parent_id ==
                                                            searchData[index]
                                                                .field) {
                                                          Multiple
                                                              .selectedItems[i]
                                                              .selectedValue = Multiple
                                                              .selectedItems[
                                                          i]
                                                              .selectedValue
                                                              .trimRight() +
                                                              "," +
                                                              searchData[index]
                                                                  .subItems[i]
                                                                  .value;
                                                        }
                                                      }
                                                    } else {
                                                      MyFilter.modified =
                                                      "modified";
                                                      Multiple.selectedItems
                                                          .add(FilterModel(
                                                          searchData[index]
                                                              .field,
                                                          searchData[index]
                                                              .subItems[i]
                                                              .value));
                                                    }
                                                  }
                                                });
                                                updateTheData();
                                              });
                                        },
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemCount:
                                        searchData[index].subItems.length),
                                  )
                            ],
                          ),
                        );
                      } else {
                        if (searchData[index]
                            .name
                            .toLowerCase()
                            .startsWith(filter.toLowerCase())) {
                          return ListTile(
                            title: Column(
                              children: [
                                CheckboxListTile(
                                    controlAffinity:
                                    ListTileControlAffinity.leading,
                                    title: Text(
                                      searchData[index].name,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          fontFamily: "Helvetica",
                                          color: Colors.black),
                                    ),
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,
                                    value: searchData[index].selected,
                                    onChanged: (bool val) {
                                      setState(() {
                                        searchData[index].selected =
                                        !searchData[index].selected;
                                        if (searchData[index].selected) {
                                          MyFilter.modified = "modified";
                                          Multiple.removetag = "";
                                          if (Multiple.selectedItems.length >
                                              0 &&
                                              Multiple.selectedItems != null) {
                                            for (int i = 0;
                                            i <
                                                Multiple
                                                    .selectedItems.length;
                                            i++) {
                                              if (Multiple.selectedItems[i]
                                                  .parent_id ==
                                                  widget.id) {
                                                Multiple.selectedItems[i]
                                                    .selectedValue = Multiple
                                                    .selectedItems[i]
                                                    .selectedValue
                                                    .trimRight() +
                                                    "," +
                                                    searchData[index].value;
                                              }
                                            }
                                          } else {
                                            Multiple.selectedItems.add(
                                                FilterModel(widget.id,
                                                    searchData[index].value));
                                          }
                                          updateTheData();

                                          searchData[index]
                                              .subItems
                                              .forEach((element) {
                                            setState(() {
                                              element.selected = true;
                                              print(element.value);
                                              Multiple.removetag = "";
                                              if (Multiple.selectedItems !=
                                                  null &&
                                                  Multiple.selectedItems
                                                      .length >
                                                      0) {
                                                for (int forIndex = 0;
                                                forIndex <
                                                    Multiple.selectedItems
                                                        .length;
                                                forIndex++) {
                                                  if (Multiple
                                                      .selectedItems[
                                                  forIndex]
                                                      .parent_id ==
                                                      searchData[index].field) {
                                                    Multiple
                                                        .selectedItems[forIndex]
                                                        .selectedValue = Multiple
                                                        .selectedItems[
                                                    forIndex]
                                                        .selectedValue
                                                        .trimRight() +
                                                        "," +
                                                        element.value;
                                                  }
                                                }
                                              } else {
                                                Multiple.selectedItems.add(
                                                    FilterModel(
                                                        searchData[index].field,
                                                        element.value));
                                              }
                                            });
                                            updateTheData();
                                          });
                                        } else {
                                          MyFilter.modified = "modified";
                                          searchData[index]
                                              .subItems
                                              .forEach((element) {
                                            if (element.selected == true) {
                                              element.selected = false;
                                              selectedSubItem
                                                  .add(element.value);
                                            }
                                          });

                                          /* searchData[index]
                                        .subItems
                                        .forEach((element) {
                                      element.selected = false;
                                    });*/
                                          Multiple.removetag = "remove";
                                          if (Multiple.selectedItems.length >
                                              0 &&
                                              Multiple.selectedItems != null) {
                                            for (int i = 0;
                                            i <
                                                Multiple
                                                    .selectedItems.length;
                                            i++) {
                                              if (Multiple.selectedItems[i]
                                                  .parent_id ==
                                                  widget.id) {
                                                Multiple.selectedItems[i]
                                                    .selectedValue = Multiple
                                                    .selectedItems[i]
                                                    .selectedValue
                                                    .trimRight() +
                                                    "," +
                                                    searchData[index].value;
                                              }
                                            }
                                          } else {
                                            MyFilter.modified = "modified";
                                            Multiple.selectedItems.add(
                                                FilterModel(widget.id,
                                                    searchData[index].value));
                                          }
                                          updateTheData();
                                        }
                                      });
                                      // updateTheData();
                                    }),
                                if (searchData[index].subItems.isNotEmpty)
                                  if (searchData[index].selected)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 26),
                                      child: ListView.separated(
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, int i) {
                                            return CheckboxListTile(
                                                contentPadding:
                                                EdgeInsets.only(left: 5),
                                                title: Text(
                                                  searchData[index]
                                                      .subItems[i]
                                                      .name,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 13.5,
                                                      fontFamily: "Helvetica",
                                                      color: Colors.black),
                                                  softWrap: true,
                                                ),
                                                controlAffinity:
                                                ListTileControlAffinity
                                                    .leading,
                                                activeColor: Colors.white,
                                                checkColor: Colors.black,
                                                value: searchData[index]
                                                    .subItems[i]
                                                    .selected,
                                                onChanged: (bool val) {
                                                  setState(() {
                                                    searchData[index]
                                                        .subItems[i]
                                                        .selected =
                                                    !searchData[index]
                                                        .subItems[i]
                                                        .selected;
                                                    print(searchData[index]
                                                        .subItems[i]
                                                        .value);
                                                    print(searchData[index]
                                                        .field);
                                                    if (searchData[index]
                                                        .subItems[i]
                                                        .selected ==
                                                        true) {
                                                      MyFilter.modified =
                                                      "modified";
                                                      Multiple.removetag = "";
                                                      if (Multiple.selectedItems !=
                                                          null &&
                                                          Multiple.selectedItems
                                                              .length >
                                                              0) {
                                                        for (int forIndex = 0;
                                                        forIndex <
                                                            Multiple
                                                                .selectedItems
                                                                .length;
                                                        forIndex++) {
                                                          if (Multiple
                                                              .selectedItems[
                                                          forIndex]
                                                              .parent_id ==
                                                              searchData[index]
                                                                  .field) {
                                                            Multiple
                                                                .selectedItems[
                                                            forIndex]
                                                                .selectedValue = Multiple
                                                                .selectedItems[
                                                            forIndex]
                                                                .selectedValue
                                                                .trimRight() +
                                                                "," +
                                                                searchData[
                                                                index]
                                                                    .subItems[i]
                                                                    .value;
                                                          }
                                                        }
                                                      } else {
                                                        Multiple.selectedItems
                                                            .add(FilterModel(
                                                            searchData[
                                                            index]
                                                                .field,
                                                            searchData[
                                                            index]
                                                                .subItems[i]
                                                                .value));
                                                      }
                                                    } else {
                                                      MyFilter.modified =
                                                      "modified";
                                                      Multiple.removetag =
                                                      "remove";
                                                      if (Multiple.selectedItems
                                                          .length >
                                                          0 &&
                                                          Multiple.selectedItems !=
                                                              null) {
                                                        for (int i = 0;
                                                        i <
                                                            Multiple
                                                                .selectedItems
                                                                .length;
                                                        i++) {
                                                          if (Multiple
                                                              .selectedItems[
                                                          i]
                                                              .parent_id ==
                                                              searchData[index]
                                                                  .field) {
                                                            Multiple
                                                                .selectedItems[
                                                            i]
                                                                .selectedValue = Multiple
                                                                .selectedItems[
                                                            i]
                                                                .selectedValue
                                                                .trimRight() +
                                                                "," +
                                                                searchData[
                                                                index]
                                                                    .subItems[i]
                                                                    .value;
                                                          }
                                                        }
                                                      } else {
                                                        MyFilter.modified =
                                                        "modified";
                                                        Multiple.selectedItems
                                                            .add(FilterModel(
                                                            searchData[
                                                            index]
                                                                .field,
                                                            searchData[
                                                            index]
                                                                .subItems[i]
                                                                .value));
                                                      }
                                                    }
                                                  });
                                                  updateTheData();
                                                });
                                          },
                                          separatorBuilder: (context, index) =>
                                              Divider(),
                                          itemCount: searchData[index]
                                              .subItems
                                              .length),
                                    )
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }
                    },
                    separatorBuilder: (context, index) {
                      return (filter == "" || filter == null)
                          ? Divider()
                          : Center();
                    },
                  ),
                ))
        ],
      ),
    );
  }

  Padding withTitle() {
    return Padding(
        padding: EdgeInsets.only(top: 55, bottom: 60),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchTitleData.length,
            itemBuilder: (BuildContext context, int index) {
              return /*ListTile(

                title: */Padding(
                padding: EdgeInsets.only(left:10,right:10,top:15),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left:10,right:10),
                      height: 30,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            searchTitleData[index].selected =
                            !searchTitleData[index].selected;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              searchTitleData[index].title,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.5,
                                  fontFamily: "Helvetica",
                                  color: Colors.black),
                            ),
                            Icon(searchTitleData[index].selected
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    if (searchTitleData[index].list.isNotEmpty)
                      if (searchTitleData[index].selected)
                        Padding(
                          padding:  EdgeInsets.only(left:5,bottom: 30),
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: searchTitleData[index].list.length,
                            itemBuilder: (context, int i) {
                              return Column(
                                children: [
                                  CheckboxListTile(
                                      title: Text(
                                        searchTitleData[index].list[i].name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.5,
                                            fontFamily: "Helvetica",
                                            color: Colors.black),
                                        softWrap: true,
                                      ),
                                      controlAffinity:
                                      ListTileControlAffinity.leading,
                                      activeColor: Colors.black,
                                      checkColor: Colors.white,
                                      value: searchTitleData[index].list[i].selected,
                                      onChanged: (bool val) {
                                        setState(() {
                                          searchTitleData[index].list[i].selected =
                                          !searchTitleData[index].list[i].selected;

                                          if (searchTitleData[index].list[i].selected) {
                                            MyFilter.modified="done";
                                            Multiple.removetag = "";
                                            if (Multiple.selectedItems.length > 0 && Multiple.selectedItems != null) {
                                              for (int i = 0; i < Multiple.selectedItems.length; i++) {
                                                if (Multiple.selectedItems[i]
                                                    .parent_id ==
                                                    widget.id) {
                                                  Multiple.selectedItems[i]
                                                      .selectedValue = Multiple
                                                      .selectedItems[i]
                                                      .selectedValue
                                                      .trimRight() +
                                                      "," +
                                                      searchTitleData[index].list[i].value;
                                                }
                                              }
                                            } else {
                                              Multiple.selectedItems.add(
                                                  FilterModel(widget.id,
                                                      searchTitleData[index].list[i].value));
                                            }
                                            updateTheData();
                                            searchTitleData[index].list[i].subItems.forEach((element) {
                                              setState(() {
                                                element.selected = true;
                                                print(element.value);
                                                Multiple.removetag = "";
                                                if (Multiple.selectedItems != null && Multiple.selectedItems.length > 0 ) {
                                                  for (int forIndex = 0; forIndex < Multiple.selectedItems.length; forIndex++) {
                                                    if (Multiple
                                                        .selectedItems[forIndex].parent_id == searchData[index].field) {
                                                      Multiple.selectedItems[forIndex].selectedValue = Multiple.selectedItems[forIndex].selectedValue
                                                          .trimRight() +
                                                          "," + element
                                                          .value;
                                                    }
                                                  }
                                                } else {
                                                  Multiple.selectedItems
                                                      .add(FilterModel(searchTitleData[index].list[i].field,
                                                      element
                                                          .value));
                                                }
                                              });
                                              updateTheData();
                                            });
                                          }
                                          else {
                                            MyFilter.modified="done";
                                            searchTitleData[index].list[i].subItems.forEach((element) {
                                              if(element.selected==true){
                                                element.selected = false;
                                                selectedSubItem.add(element.value);
                                              }
                                            });




                                            Multiple.removetag = "remove";
                                            if (Multiple.selectedItems.length > 0 && Multiple.selectedItems != null) {
                                              for (int i = 0; i < Multiple.selectedItems.length; i++) {
                                                if (Multiple.selectedItems[i].parent_id == widget.id) {
                                                  Multiple.selectedItems[i].selectedValue = Multiple.selectedItems[i].selectedValue.trimRight() + "," + searchTitleData[index].list[i].value;
                                                }
                                              }
                                            } else {
                                              Multiple.selectedItems.add(
                                                  FilterModel(
                                                      widget.id,
                                                      searchTitleData[index]
                                                          .list[i]
                                                          .value));
                                            }
                                            updateTheData();
                                          }

                                        });
                                         updateTheData();
                                      }),
                                  if (searchTitleData[index].list[i].subItems.isNotEmpty)
                                    if (searchTitleData[index].list[i].selected)
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 18),
                                        child: ListView.separated(
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: searchTitleData[index]
                                              .list[i]
                                              .subItems
                                              .length,
                                          itemBuilder: (context, int subItems) {
                                            return CheckboxListTile(
                                                title: Text(searchTitleData[index].list[i]
                                                    .subItems[subItems].name,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 14,
                                                      fontFamily: "Helvetica",
                                                      color: Colors.black),
                                                  softWrap: true,
                                                ),
                                                controlAffinity:
                                                ListTileControlAffinity
                                                    .leading,
                                                activeColor: Colors.white,
                                                checkColor: Colors.black,
                                                value: searchTitleData[index]
                                                    .list[i]
                                                    .subItems[subItems]
                                                    .selected,
                                                onChanged: (bool val) {
                                                  setState(() {
                                                    searchTitleData[index]
                                                        .list[i]
                                                        .subItems[subItems]
                                                        .selected =
                                                    !searchTitleData[index]
                                                        .list[i]
                                                        .subItems[subItems]
                                                        .selected;

                                                    //3rd layer

                                                    print(
                                                        "SELECTED ${searchTitleData[index].list[i].subItems[subItems].selected}");
                                                    // print(
                                                    //     "3rd layer${Multiple
                                                    //         .selectedItems[i]
                                                    //         .parent_id}");
                                                    if (searchTitleData[index]
                                                        .list[i]
                                                        .subItems[subItems]
                                                        .selected ==
                                                        true) {
                                                      Multiple.removetag = "";
                                                      if (Multiple.selectedItems
                                                          .length >
                                                          0 &&
                                                          Multiple.selectedItems !=
                                                              null) {
                                                        for (int forIndex = 0;
                                                        forIndex <
                                                            Multiple
                                                                .selectedItems
                                                                .length;
                                                        forIndex++) {
                                                          if (Multiple
                                                              .selectedItems[
                                                          forIndex]
                                                              .parent_id ==
                                                              searchTitleData[
                                                              index]
                                                                  .list[i]
                                                                  .field) {
                                                            print(
                                                                "3rd layer${Multiple.selectedItems[forIndex].parent_id}");
                                                            print(
                                                                "Field ${searchTitleData[index].list[forIndex].field}");
                                                            Multiple
                                                                .selectedItems[
                                                            forIndex]
                                                                .selectedValue = Multiple
                                                                .selectedItems[
                                                            forIndex]
                                                                .selectedValue
                                                                .trimRight() +
                                                                "," +
                                                                searchTitleData[
                                                                index]
                                                                    .list[i]
                                                                    .subItems[
                                                                subItems]
                                                                    .value;
                                                          }
                                                        }
                                                      } else {
                                                        print(
                                                            "INNER NESTING ${searchTitleData[index].list[i].field}");
                                                        print(
                                                            "INNER NESTING ${searchTitleData[index].list[i].subItems[subItems].value}");
                                                        Multiple.selectedItems
                                                            .add(FilterModel(
                                                            searchTitleData[
                                                            index]
                                                                .list[i]
                                                                .field,
                                                            searchTitleData[
                                                            index]
                                                                .list[i]
                                                                .subItems[
                                                            subItems]
                                                                .value));
                                                      }

                                                      print(Multiple
                                                          .selectedItems
                                                          .length);
                                                    } else {
                                                      Multiple.removetag = "remove";
                                                      if (Multiple.selectedItems.length > 0 &&
                                                          Multiple.selectedItems != null) {
                                                        for (int i = 0; i < Multiple.selectedItems.length; i++) {
                                                          if (Multiple.selectedItems[i].parent_id == searchTitleData[index].list[i].field) {
                                                            Multiple.selectedItems[i].selectedValue = Multiple.selectedItems[i].selectedValue.trimRight() + "," + searchTitleData[index].list[i].subItems[subItems].value;
                                                          }
                                                        }
                                                      } else {
                                                        Multiple.selectedItems
                                                            .add(FilterModel(
                                                            searchTitleData[
                                                            index]
                                                                .list[i]
                                                                .field,
                                                            searchTitleData[
                                                            index]
                                                                .list[i]
                                                                .subItems[
                                                            subItems]
                                                                .value));
                                                      }
                                                    }
                                                  });
                                                  updateTheData();
                                                });

                                          },
                                          separatorBuilder: (context, index) =>
                                              Divider(),
                                        ),
                                      )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                          ),
                        )
                  ],
                ),
              );
              /*);*/
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ));
  }

  void filterQuery(String query) {
    if (searchTitleData.isEmpty) {
      // searchData.addAll(widget.items);

      print("ENTERED IF");

      List<FilterItems> dynamicSearchList = List<FilterItems>();

      // searchData.addAll(widget.items);
      dynamicSearchList.addAll(widget.items);
      print("SEARCH DATA ${searchData.length}");
      print("SEARCH TITLE DATA ${searchTitleData.length}");
      print("Dynamic ${dynamicSearchList.length}");
      print("Query $query");
      if (query.isNotEmpty) {
        List<FilterItems> dynamicSearchData = List<FilterItems>();
        dynamicSearchList.forEach((item) {
          if (item.name.toLowerCase().startsWith(query.toLowerCase())) {
            // print("ITEM ${searchData.indexOf(item)}");
            dynamicSearchData.add(item);
          }
        });
        setState(() {
          print(widget.items.length);
          searchData.clear();
          searchData.addAll(dynamicSearchData);
          print("After FILTER ${searchData.length}");
        });
        // return;
      } else {
        print("ENTERED ELSE");
        print(widget.items.length);

        setState(() {
          searchData.clear();
          searchData.addAll(widget.items);
        });
      }
    } else {
      setState(() {
        widget.search = true;
        // searchtitleData.clear();
        // widget.titleItems.clear();
      });
      List<FilterItems> dynamicSearchList = List<FilterItems>();
      searchTitleData.forEach((element) {
        // dynamicSearchList = element.list;
        dynamicSearchList.addAll(element.list);
      });
      // searchTitleData.clear();
      // print("Dynamic ${dynamicSearchList.length}");
      // print("SEARCH DATA ${searchData.length}");
      // print("SEARCH TITLE DATA ${searchTitleData.length}");

      if (query.isNotEmpty) {
        List<FilterItems> dynamicSearchData = List<FilterItems>();
        dynamicSearchList.forEach((item) {
          if (item.name.toLowerCase().startsWith(query.toLowerCase())) {
            // print("ITEM ${searchData.indexOf(item)}");
            dynamicSearchData.add(item);
          }
        });
        setState(() {
          searchData.clear();
          searchData.addAll(dynamicSearchData);
          print("After FILTER ${searchData.length}");
        });
        // return;
      } else {
        setState(() {
          searchData.clear();
          widget.search = false;
          // searchTitleData.addAll(widget.titleItems);
        });
      }
    }
  }

  Widget searchBox(String hintText) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            height: 50,
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
            child: TextField(
                onTap: () {
                  print("");
                },
                enabled: true,
                onChanged: (value) {
                  print(widget.items.isEmpty);
                  print(widget.titleItems.isEmpty);
                  if (widget.titleItems.isEmpty) {
                    setState(() {
                      filter = value;
                    });
                  } else {
                    filterQuery(value);
                  }
                  // if(widget.items.isEmpty){
                  //
                  // }
                  // else{
                  //
                  // }

                  // filterQuery(value);
                  print("FILTER QUERY: $value");
                },
                // controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: hintText,
                    hintStyle: TextStyle(fontSize: 11, fontFamily: "Helvetica"),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()))));
  }

  void updateTheData() {
    setState(() {
      if (Multiple.selectedItems != null && Multiple.selectedItems.length > 0) {
        setState(() {
          if(Multiple.selectedItems.first.parent_id=="category_id"){
            final index = MyFilter.filterModel.indexWhere((element) => element.parent_id == Multiple.selectedItems.first.parent_id);
            final subcategory=MyFilter.filterModel.indexWhere((element) => element.parent_id=="sub_category_id");
            print("SubCategory: ${subcategory.toString()}");
            print("INDEX VALUE: $index");
            if (index != -1) {
              if (Multiple.removetag == "") {
                MyFilter.filterModel[index].selectedValue += "," + Multiple.selectedItems[0].selectedValue;
              }
              else {

                if (Multiple.selectedItems[0].selectedValue.contains(",")) {
                  List<String> removedValue =Multiple.selectedItems[0].selectedValue.split(",");
                  for (int i = 0; i < removedValue.length; i++) {
                    MyFilter.filterModel[index].selectedValue = MyFilter
                        .filterModel[index].selectedValue
                        .replaceAll(removedValue[i].trimRight(), "null");
                  }
                } else {

                  List match = MyFilter.filterModel[index].selectedValue.split(',');

                  List childIMatch =MyFilter.filterModel[subcategory].selectedValue.split(',');

                  String updatedValue = "";
                  String childValue="";
                  String childReplaceComma="";
                  String replaceComma = "";
                  for(int i=0;i<match.length;i++){

                    if(match[i]==Multiple.selectedItems[0].selectedValue){
                      match[i]="null";
                      for(int j=0;j<selectedSubItem.length;j++){
                        if(j>=1){
                          childIMatch=[];
                          childIMatch= childValue.split(',');
                          childValue="";
                          for(int k=0;k<childIMatch.length;k++){
                            if(selectedSubItem[j]==childIMatch[k]){
                              childIMatch[j]="null";
                              childIMatch[k]="null";
                            }
                            childReplaceComma = (k==childIMatch.length-1) ?"":",";
                            childValue+=childIMatch[k]+childReplaceComma;
                          }
                        }
                        else{
                          for(int k=0;k<childIMatch.length;k++){
                            if(selectedSubItem[j]==childIMatch[k]){
                              childIMatch[j]="null";
                              childIMatch[k]="null";
                            }
                            childReplaceComma = (k==childIMatch.length-1)?"":",";
                            childValue+=childIMatch[k]+childReplaceComma;
                          }
                        }
                      }
                    }
                    replaceComma = (i==match.length-1)?"":",";
                    updatedValue+=match[i]+replaceComma;
                  }

                  print("Updated Value $updatedValue");
                  MyFilter.filterModel[index].selectedValue = updatedValue.trim();
                  MyFilter.filterModel[subcategory].selectedValue = childValue.trim();
                }
              }
            } else {
              MyFilter.filterModel.addAll(Multiple.selectedItems);
            }
          }
          else{
            final index = MyFilter.filterModel.indexWhere((element) => element.parent_id == Multiple.selectedItems.first.parent_id);
            print("INDEX VALUE: $index");
            if (index != -1) {
              if (Multiple.removetag == "") {
                MyFilter.filterModel[index].selectedValue +=
                    "," + Multiple.selectedItems[0].selectedValue;
              } else {
                if (Multiple.selectedItems[0].selectedValue.contains(",")) {
                  List<String> removedValue =
                  Multiple.selectedItems[0].selectedValue.split(",");
                  for (int i = 0; i < removedValue.length; i++) {
                    MyFilter.filterModel[index].selectedValue = MyFilter
                        .filterModel[index].selectedValue
                        .replaceAll(removedValue[i].trimRight(), "null");
                  }
                } else {
                  print("MULTIPLE FILE: ${MyFilter.filterModel[index].selectedValue}");
                  List match =MyFilter.filterModel[index].selectedValue.split(',');
                  String updatedValue = "";
                  String replaceComma = "";
                  for(int i=0;i<match.length;i++){
                    if(match[i]==Multiple.selectedItems[0].selectedValue){
                      match[i]="null";
                    }
                    replaceComma = (i==match.length-1)?"":",";
                    updatedValue+=match[i]+replaceComma;
                  }

                  print("Updated Value $updatedValue");
                  MyFilter.filterModel[index].selectedValue = updatedValue.trim();
                }
              }
            } else {
              MyFilter.filterModel.addAll(Multiple.selectedItems);
            }
            print("MYFILTER LENGTH: ${MyFilter.filterModel}");

          }


          print("MYFILTER LENGTH: ${MyFilter.filterModel}");
        });
        Multiple.selectedItems.clear();
      }
    });
  }
}
