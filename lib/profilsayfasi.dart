import 'package:blog/anasayfa.dart';
import 'package:blog/main.dart';
import 'package:blog/yazisayfasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Sayfası"),
        actions: [
          IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((deger) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AnaSayfa()),
                      (Route<dynamic> route) => true);
                });
              }),
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((deger) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Iskele()),
                      (Route<dynamic> route) => false);
                });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const YaziEkrani()),
                (Route<dynamic> route) => true);
          }),
      body: const TumYazilar(),
    );
  }
}

class TumYazilar extends StatefulWidget {
  const TumYazilar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserInformationState createState() => _UserInformationState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _UserInformationState extends State<TumYazilar> {
  Query blogYazilari = FirebaseFirestore.instance
      .collection('Yazilar')
      .where("kullaniciid", isEqualTo: auth.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: blogYazilari.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['baslik']),
              subtitle: Text(data['icerik']),
            );
          }).toList(),
        );
      },
    );
  }
}
