
import 'package:azaFashions/ui/BaseFiles/DetailPage.dart';
import 'package:flutter/material.dart';

//BANNER IMAGES WITH PAGE VIEW

class ViewAllText extends StatefulWidget {
  String view_all_url, title;
  ViewAllText(this.view_all_url,this.title);
  @override
  _ItemDesignState createState() => _ItemDesignState();
}

class _ItemDesignState extends State<ViewAllText> {

  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return
    Column(
      children: [
        Container(padding:EdgeInsets.only(top:20),child: Divider(thickness: 2,color: Colors.grey[300],)),
        Padding(
            padding: EdgeInsets.only(top:3,bottom: 50),
            child:Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child:  InkWell(
                onTap:(){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (__) => new DetailPage("Collection", widget.view_all_url)));


              },
                  child: Align(alignment:Alignment.center,child: Text('${widget.title}', textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:16,fontFamily: "Helvetica",color: Colors.black38),))),

            )
        ),
      ],
    );
  }

 }
