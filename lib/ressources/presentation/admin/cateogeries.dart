import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:soretrak/models/cateogery.dart';
import 'package:soretrak/ressources/dimensions/constants.dart';
import 'package:soretrak/ressources/presentation/admin/add_category.dart';
import 'package:soretrak/ressources/presentation/admin/update_cateogery.dart';
import 'package:unicons/unicons.dart';

class Cateogeries extends StatefulWidget {
  const Cateogeries({Key? key}) : super(key: key);

  @override
  State<Cateogeries> createState() => _CateogeriesState();
}

class _CateogeriesState extends State<Cateogeries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategory()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('cateogeries').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Category> catg = [];
              for (var data in snapshot.data!.docs.toList()) {
                catg.add(Category.fromJson(data.data() as Map<String, dynamic>));
              }
              if (catg.isNotEmpty) {
                return ListView.builder(
                  itemCount: catg.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              borderRadius: BorderRadius.circular(10),
                              onPressed: null,
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.cancel,
                            ),
                            SlidableAction(
                              onPressed: (ctx) async {
                                /// delete articles first of all
                                var arts = await FirebaseFirestore.instance
                                    .collection('articles')
                                    .where("idCat", isEqualTo: catg[index].id)
                                    .get();
                                List<String> articles = [];
                                for (var data in arts.docs.toList()) {
                                  articles.add(data.id);
                                  data.reference.delete();
                                }

                                if (articles.isNotEmpty) {
                                  /// delete req
                                  var req = await FirebaseFirestore.instance
                                      .collection('requests')
                                      .where("articleId", whereIn: articles)
                                      .get();
                                  for (var data in req.docs.toList()) {
                                    data.reference.delete();
                                  }
                                }

                                /// delete category
                                snapshot.data!.docs[index].reference.delete();
                              },
                              borderRadius: BorderRadius.circular(10),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (ctx) async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => UpdateCateogery(data: snapshot.data!.docs[index])));
                              },
                              borderRadius: BorderRadius.circular(10),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                            ),
                            SlidableAction(
                              borderRadius: BorderRadius.circular(10),
                              onPressed: null,
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.cancel,
                            ),
                          ],
                        ),
                        child: Container(
                          width: double.infinity,
                          height: Constants.screenHeight * 0.1,
                          decoration:
                              BoxDecoration(color: Colors.indigo.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  UniconsLine.clipboard_alt,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Nom  de cateogerie : ${catg[index].name} ",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Container(
                    height: Constants.screenHeight * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Pas des cateogeries pour le moment "),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
