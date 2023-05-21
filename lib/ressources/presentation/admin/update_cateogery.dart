import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';
import 'package:soretrak/ressources/presentation/widgets/input_field.dart';

class UpdateCateogery extends StatefulWidget {
  final QueryDocumentSnapshot data;
  const UpdateCateogery({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateCateogery> createState() => _UpdateCateogeryState();
}

class _UpdateCateogeryState extends State<UpdateCateogery> {
  TextEditingController name = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.data.get("name");
  }

  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Modifier une cateogerie",
          style: TextStyle(color: Colors.indigo),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.indigo),
        elevation: 0,
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            InputField(label: "Nom", textInputType: TextInputType.text, controller: name),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07),
                    child: Container(
                        width: double.infinity,
                        child: CupertinoButton(
                            color: Colors.indigo,
                            child: Text("Modifier"),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                var doc = FirebaseFirestore.instance
                                    .collection('cateogeries')
                                    .doc(widget.data.id)
                                    .update({'name': name.text});

                                setState(() {
                                  loading = false;
                                  name.clear();
                                  Navigator.pop(context);
                                });
                              }
                            })),
                  )
          ],
        ),
      ),
    );
  }
}
