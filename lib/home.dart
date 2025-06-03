import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatelessWidget {
  Home({super.key});
  var auth = FirebaseAuth.instance.currentUser;
  var posts = FirebaseFirestore.instance.collection("posts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home ${auth!.email}"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            icon: Icon(Icons.logout),
          ),
        ],
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
                          (item) => ListTile(
                            title: Text(item.get("title")),
                            subtitle: Text(item.get("body")),
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
