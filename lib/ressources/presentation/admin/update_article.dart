import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soretrak/models/cateogery.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';
import 'package:soretrak/ressources/presentation/widgets/input_field.dart';

class UpdateArticle extends StatefulWidget {
  final QueryDocumentSnapshot data;

  const UpdateArticle({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateArticle> createState() => _UpdateArticleState();
}

class _UpdateArticleState extends State<UpdateArticle> {
  late Category selectedCategory;
  List<Category> categories = [];
  getCatgs() async {
    setState(() {
      firstLoading = true;
    });
    var userData = await FirebaseFirestore.instance.collection('cateogeries').get();

    List<Category> cateogery = [];
    for (var data in userData.docs.toList()) {
      cateogery.add(Category.fromJson(data.data() as Map<String, dynamic>));
    }
    var ctg = await FirebaseFirestore.instance.collection('cateogeries').doc(widget.data.get("idCat")).get();
    setState(() {
      categories = cateogery;
      marque.text = widget.data.get("marque");
      name.text = widget.data.get("name");
      quantity.text = widget.data.get("quantity").toString();
      marque.text = widget.data.get("marque");
      Category test = Category.fromJson(ctg.data() as Map<String, dynamic>);
      if (categories.isNotEmpty) {
        selectedCategory = categories.firstWhere((category) => category.id == test.id);
      }
      //int index = categories.indexWhere((category) => category.id == selectedCategory.id);
      /*    if (categories.any((category) => category.id == selectedCategory.id)) {
        if (index != -1) {
          categories.removeAt(index);
          print('Object with ID ${selectedCategory.id} removed from the list');
        } else {
          print('Object with ID ${se} does not exist in the list');
        }
      }
      print(selectedCategory.toJson());

      print(categories[0].toJson());*/
      firstLoading = false;
    });
  }

  TextEditingController marque = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool firstLoading = false;
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
          "Modifier un article",
          style: TextStyle(color: Colors.indigo),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.indigo),
        elevation: 0,
      ),
      body: firstLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
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
                                  key: Key(category.id),
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
                                  child: Text("Modifier"),
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      if (selectedCategory != null) {
                                        setState(() {
                                          loading = true;
                                        });

                                        var doc = FirebaseFirestore.instance.collection("articles").doc(widget.data.id);
                                        doc.update({
                                          "marque": marque.text,
                                          "quantity": int.tryParse(quantity.text),
                                          "name": name.text,
                                          'idCat': selectedCategory.id
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
