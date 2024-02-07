import 'package:flutter/cupertino.dart';
import 'package:my_notes/utiles/generic_dialog.dart';

Future<bool>showDeleteDialog(BuildContext context){
  return showGenericDialog<bool>(
      context: context,
      title: 'Delete',
      content: 'Are you sure want to delete',
      optionsBuilder: ()=>{
        'Cancel':false,
        'Yes':true,
      }
  ).then((value) => value ?? false);
}