import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_app/core/resourses/app_colors.dart';

class UIUtils {
  static void showLoading(BuildContext context, {bool isDismissible=true}) {
    showDialog(
      barrierDismissible:isDismissible ,
      context: context,
      builder: (context) =>
          PopScope(
            canPop:isDismissible ,
            child: CupertinoAlertDialog(content: Column(
              mainAxisSize:MainAxisSize.min ,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            )),
          ),
    );
  }
  static void hideDialog(BuildContext context){
    Navigator.pop(context);
  }
  static showMessage(BuildContext context , String message){
    showDialog(context: context, builder:(context)=>CupertinoAlertDialog(content:Text(message,style:TextStyle(color: AppColors.black) ,)));
 }
static void showToastMessage(String message,Color background){
  Fluttertoast.showToast(
    gravity:ToastGravity.BOTTOM ,
    msg:message,
   backgroundColor: background,
   textColor:Colors.white,
    fontSize: 16.0


  );

}





}
