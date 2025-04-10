import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                ),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
            Icon(Icons.edit_outlined, color: Colors.black, size: 18,),
            SizedBox(width: 5),
            Text('Edit', style: TextStyle(color: Colors.black, fontSize: 15),),
          ],
        ),
      );
    
  }
}
