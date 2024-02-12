import 'package:flutter/cupertino.dart';
import 'package:my_notes/utiles/generic_dialog.dart';

Future<void>showCannotShareEmptyDialog(BuildContext context){
  return showGenericDialog<void>(
      context: context,
      title: 'sharing',
      content: 'you cannot share an empty note!',
      optionsBuilder: ()=>{
        'OK':null,
      }
  );
}