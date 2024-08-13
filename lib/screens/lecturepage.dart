import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LecturePage extends StatelessWidget {
  final String subjectName;

  const LecturePage({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('subjects')
                  .doc(subjectName)
                  .collection('lectures')
                  .orderBy('created_at',
                      descending: true) // ترتيب العناصر حسب الأحدث
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.asset('assets/images/splash.png'),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          "لا توجد محاضرات بعد",
                          style: TextStyle(
                            color: Color.fromARGB(255, 13, 73, 194),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: snapshot.data!.docs.map((doc) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          onTap: () async {
                            showLoadingDialog(context); // إظهار مؤشر التحميل
                            final url = doc['file_url'];
                            final file =
                                await downloadPDFFromFirebase(url, context);
                            Navigator.pop(context); // إخفاء مؤشر التحميل
                            if (file != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDFViewerPage(
                                    file: file,
                                    title: doc['file_name'],
                                  ),
                                ),
                              );
                            }
                          },
                          leading: const Icon(Icons.picture_as_pdf,
                              color: Colors.redAccent, size: 40),
                          title: Text(
                            doc['file_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            "تمت الإضافة في: ${formatTimestamp(doc['created_at'])}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.download,
                                    color: Colors.blue),
                                onPressed: () async {
                                  showLoadingDialog(
                                      context); // إظهار مؤشر التحميل
                                  final url = doc['file_url'];
                                  try {
                                    await launch(url);
                                  } catch (e) {
                                    print(e);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('لا يمكن فتح الرابط: $e')),
                                    );
                                  } finally {
                                    Navigator.pop(
                                        context); // إخفاء مؤشر التحميل
                                  }
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  bool confirmDelete =
                                      await showDeleteConfirmationDialog(
                                          context);
                                  if (confirmDelete) {
                                    await deleteLecture(doc, context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }

  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print('Signed in with temporary account.');
    } catch (e) {
      print('Failed to sign in anonymously: $e');
    }
  }

  Future<File?> downloadPDFFromFirebase(
      String url, BuildContext context) async {
    try {
      await signInAnonymously(); // تسجيل الدخول بشكل مجهول قبل محاولة التنزيل
      final ref = FirebaseStorage.instance.refFromURL(url);
      final bytes = await ref.getData();
      if (bytes != null) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/temp.pdf');
        await file.writeAsBytes(bytes, flush: true);
        return file;
      }
    } catch (e) {
      print("Error downloading PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء تحميل الملف: $e')),
      );
    }
    return null;
  }

  Future<void> deleteLecture(DocumentSnapshot doc, BuildContext context) async {
    try {
      showLoadingDialog(context); // إظهار مؤشر التحميل
      // حذف الملف من Firebase Storage
      final ref = FirebaseStorage.instance.refFromURL(doc['file_url']);
      await ref.delete();

      // حذف المستند من Firestore
      await FirebaseFirestore.instance
          .collection('subjects')
          .doc(subjectName)
          .collection('lectures')
          .doc(doc.id)
          .delete();

      Navigator.pop(context); // إخفاء مؤشر التحميل
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف المحاضرة بنجاح')),
      );
    } catch (e) {
      Navigator.pop(context); // إخفاء مؤشر التحميل في حالة حدوث خطأ
      print("Error deleting lecture: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء حذف المحاضرة: $e')),
      );
    }
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("تأكيد الحذف"),
              content: const Text("هل أنت متأكد من أنك تريد حذف هذه المحاضرة؟"),
              actions: <Widget>[
                TextButton(
                  child: const Text("إلغاء"),
                  onPressed: () {
                    Navigator.of(context).pop(false); // إغلاق الحوار بدون حذف
                  },
                ),
                TextButton(
                  child: const Text("حذف"),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // إغلاق الحوار مع تأكيد الحذف
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("جاري التحميل...", style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final File file;
  final String title;

  const PDFViewerPage({super.key, required this.file, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}
