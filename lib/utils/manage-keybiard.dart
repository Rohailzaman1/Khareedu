import 'package:flutter/material.dart';
class keyboardutils
{
  static void hideKeyboard(BuildContext context){
  FocusScopeNode currentFocus = FocusScope.of(context);
      if(!currentFocus.hasPrimaryFocus)
        {
          currentFocus.unfocus();
        }
  }


}
