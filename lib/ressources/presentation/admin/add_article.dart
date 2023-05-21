import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soretrak/models/cateogery.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';
import 'package:soretrak/ressources/presentation/widgets/input_field.dart';

class AddArticle extends StatefulWidget {
  final String code;
  const AddArticle({Key? key, required this.code}) : super(key: key);

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  List<Category> categories = [];
  getCatgs() async {
    var userData = await FirebaseFirestore.instance.collection('cateogeries').get();
    print(userData.docs.toList());
    List<Category> cateogery = [];
    for (var data in userData.docs.toList()) {
      cateogery.add(Category.fromJson(data.data() as Map<String, dynamic>));
    }
    setState(() {
      categories = cateogery;
    });
  }

  Category? selectedCategory;
  TextEditingController marque = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCatgs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ajouter un article",
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
            InputField(label: "Nom d'article", textInputType: TextInputType.text, controller: name),
            InputField(label: "Marque", textInputType: TextInputType.text, controller: marque),
            InputField(label: "Quantité", textInputType: TextInputType.number, controller: quantity),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07, vertical: 5),
              child: Row(
                children: [
                  Text(
                    "Cateogerie : ",
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.indigo),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: Constants.screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: DropdownButton<Category>(
                        value: selectedCategory,
                        underline: SizedBox(
                          height: 0,
                        ),
                        items: categories.map<DropdownMenuItem<Category>>((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(category.name),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                            child: Text("Ajouter"),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                if (selectedCategory != null) {
                                  setState(() {
                                    loading = true;
                                  });

                                  var doc = FirebaseFirestore.instance.collection("articles").doc(widget.code);
                                  doc.set({
                                    "id": widget.code,
                                    "marque": marque.text,
                                    "quantity": int.tryParse(quantity.text),
                                    "name": name.text,
                                    'idCat': selectedCategory!.id
                                  });
                                  Navigator.pop(context);
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text("Il faut choisir une categorie"),
                                    backgroundColor: (Colors.red),
                                    action: SnackBarAction(
                                      label: 'fermer',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }
                            })),
                  )
          ],
        ),
      ),
    );
  }
}
