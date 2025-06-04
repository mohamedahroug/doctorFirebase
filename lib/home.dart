import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase/post.dart';

class HomepPage extends StatelessWidget {
  HomepPage({super.key});
  var user = FirebaseAuth.instance.currentUser;
  var posts = FirebaseFirestore.instance.collection("posts");

  likePost(String postid) async {
    var currentPost = await posts.doc(postid).get();

    List likes = currentPost["likes"] ?? [];

    if (likes.contains(user!.uid)) {
      likes.remove(user!.uid);
    } else {
      likes.add(user!.uid);
    }

    await posts.doc(postid).update({"likes": likes});
  }
commentonPost(BuildContext context, String postid) async {
  var controller = TextEditingController();

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Add Comment"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: "Enter your Comment"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            var comment = controller.text;
            await posts.doc(postid).update({
              "comments": FieldValue.arrayUnion([
                {
                  "userId": user!.uid,
                  "text": comment,
                  "timestamp": Timestamp.now()
                },
              ])
            });
            Navigator.of(context).pop();
          },
          child: Text("Save"),
        ),
      ],
    ),
  );
}

  // commentonPost(BuildContext context, String postid) async {
  //   //["uid":"ghfghfjh","text":"fgfgfg",]
  //   var currentPost = await posts.doc(postid).get();

  //   List comments = currentPost["comments"] ?? [];

  //   var controller = TextEditingController();

  //   await showDialog(
  //     context: context,
  //     builder:
  //         (_) => AlertDialog(
  //           title: Text("Add Comment"),
  //           content: TextField(
  //             controller: controller,
  //             decoration: InputDecoration(hintText: "Enter your Comment"),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () async {
  //                 var comment = controller.text;
  //                 await posts.doc(postid).update({
  //                   "comments": FieldValue.arrayUnion([
  //                     {
  //                       "userId": user!.uid,
  //                       "test": comment,
  //                       "timestamp": Timestamp.now(),
  //                     },
  //                   ]),
  //                 });
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text("Save"),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text("Cancel"),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home ${user!.email}"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/myposts");
            },
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("/addpost");
        },
      ),
      body: StreamBuilder(
        stream: posts.snapshots(),
        builder: (context, responce) {
          if (responce.connectionState == ConnectionState.done ||
              responce.connectionState == ConnectionState.active) {
            if (responce.data!.docs.isNotEmpty) {
             
              return ListView(
                children:
                    responce.data!.docs
                        .map(
                          (item) => PostCard(
                            post: item.data(),
                            fristButtonOnPress: () {
                              likePost(item.id);
                            },
                            fristIcon: Icon(Icons.favorite),
                            secondButtonOnPress: () {
                              commentonPost(
                                context,
                                item.id,
                              ); 
                            },

                            secondIcon: Icon(Icons.comment),
                          ),
                        )
                        .toList(),
              );
            } else {
              return Center(child: Text("NO Data Found"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
