// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_firebase/EditePost.dart';
// import 'package:flutter_firebase/post.dart';

// class MyPosts extends StatefulWidget {
//   const MyPosts({super.key});

//   @override
//   State<MyPosts> createState() => _MyPostsScreenState();
// }

// class _MyPostsScreenState extends State<MyPosts> {
//   var posts = FirebaseFirestore.instance.collection("posts");
//   deletePost(String id) {
//     posts.doc(id).delete().then((_) {}).catchError((err) {
//       print(err);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Post"), actions: [
//           ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           Navigator.of(context).pushNamed("addpost");
//         },
//       ),
//       body: StreamBuilder(
//         stream:
//             posts
//                 .where(
//                   "creatorId",
//                   isEqualTo: FirebaseAuth.instance.currentUser!.uid,
//                 )
//                 .snapshots(),
//         builder: (context, responce) {
//           if (responce.connectionState == ConnectionState.done ||
//               responce.connectionState == ConnectionState.active) {
//             if (responce.data!.docs.isNotEmpty) {
//               return ListView(
//                 children:
//                     responce.data!.docs
//                         .map(
//                           (item) => PostCard(
//                             isEdit: true,
//                             post: item.data(),
//                             fristButtonOnPress: () {
//                               deletePost(item.id);
//                             },
//                             fristIcon: Icon(Icons.delete, color: Colors.red),
//                             secondButtonOnPress: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => EditPost(
//                                         postId: item.id,
//                                         postData: item.data(),
                                        
//                                       ),
//                                 ),
//                               );
//                             },
//                             secondIcon: Icon(Icons.edit, color: Colors.amber),
//                           ),
//                         )
//                         .toList(),
//               );
//             } else {
//               return Center(child: Text("NO Data Found"));
//             }
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/EditePost.dart';
import 'package:flutter_firebase/post.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPosts> {
  var posts = FirebaseFirestore.instance.collection("posts");

  // دالة الحذف مع تأكيد للمستخدم
  void deletePost(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text("Delete"),
            onPressed: () {
              posts.doc(id).delete().then((_) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Post deleted successfully")),
                );
              }).catchError((err) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to delete post: $err")),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Post"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("addpost");
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: posts
            .where("creatorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, responce) {
          if (responce.connectionState == ConnectionState.done ||
              responce.connectionState == ConnectionState.active) {
            if (responce.hasData && responce.data!.docs.isNotEmpty) {
              return ListView(
                children: responce.data!.docs
                    .map((item) => PostCard(
                          isEdit: true,
                          post: item.data() as Map<String, dynamic>,
                          fristButtonOnPress: () {
                            deletePost(item.id);
                          },
                          fristIcon: Icon(Icons.delete, color: Colors.red),
                           secondButtonOnPress: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditPost(
                                        postId: item.id,
                                        postData: item.data() as Map<String, dynamic>,
                                        
                                      ),
                                ),
                              );
                            },
                          secondIcon: Icon(Icons.edit, color: Colors.amber),
                        ))
                    .toList(),
              );
            } else {
              return Center(
                child: Text("NO Data Found"),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
