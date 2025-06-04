import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;

  const EditPost({super.key, required this.postId, required this.postData});

  @override
  State<EditPost> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPost> {
  late String title;
  late String body;
  late bool isPrivate;
  late String image;
  var key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // تحميل البيانات الحالية للمنشور إلى المتغيرات
    title = widget.postData['title'] ?? "";
    body = widget.postData['body'] ?? "";
    isPrivate = widget.postData['isPrivate'] ?? true;
    image = widget.postData['image'] ?? "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg";
  }

  savePost() {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      FirebaseFirestore.instance.collection("posts").doc(widget.postId).update({
        "title": title,
        "body": body,
        "image": (image.isEmpty || !Uri.parse(image).isAbsolute)
            ? "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"
            : image,
        "isPrivate": isPrivate,
        "timestamp": Timestamp.now(),
      }).then((_) {
        Navigator.of(context).pop();
      }).catchError((err) {
        print(err);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update post")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
      ),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(hintText: "Title"),
                onSaved: (newValue) {
                  title = newValue ?? "";
                },
                validator: (value) =>
                    value == null || value.isEmpty ? "Title required" : null,
              ),
              TextFormField(
                initialValue: body,
                decoration: InputDecoration(hintText: "Body"),
                onSaved: (newValue) {
                  body = newValue ?? "";
                },
                validator: (value) =>
                    value == null || value.isEmpty ? "Body required" : null,
              ),
              TextFormField(
                initialValue: image,
                decoration: InputDecoration(hintText: "Image URL"),
                onSaved: (newValue) {
                  image = newValue ?? "";
                },
              ),
              SwitchListTile(
                activeColor: Colors.red,
                title: Text("Only me"),
                value: isPrivate,
                onChanged: (val) {
                  setState(() {
                    isPrivate = val;
                  });
                },
              ),
              SizedBox(height: 50),
              ElevatedButton(onPressed: savePost, child: Text("Save Changes")),
            ],
          ),
        ),
      ),
    );
  }
}
