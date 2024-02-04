import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YaziEkrani extends StatefulWidget {
  const YaziEkrani({super.key});

  @override
  State<YaziEkrani> createState() => _YaziEkraniState();
}

class _YaziEkraniState extends State<YaziEkrani> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  var gelenYaziBasligi = "";
  var gelenYaziIcerigi = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  yaziEkle() {
    FirebaseFirestore.instance.collection("Yazilar").doc(t1.text).set({
      'kullaniciid': auth.currentUser?.uid,
      'baslik': t1.text,
      'icerik': t2.text
    });
  }

  yaziSil() {
    FirebaseFirestore.instance.collection("Yazilar").doc(t1.text).delete();
  }

  yaziGuncelle() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(t1.text)
        .update({'baslik': t1.text, 'icerik': t2.text});
  }

  yaziGetir() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(t1.text)
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenYaziBasligi = gelenVeri.data()?['baslik'];
        gelenYaziIcerigi = gelenVeri.data()?['icerik'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yazı Ekranı"),
      ),
      body: Container(
        margin: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: t1,
              ),
              TextField(
                controller: t2,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: yaziEkle, child: const Text("Ekle")),
                  ElevatedButton(
                      onPressed: yaziGuncelle, child: const Text("Guncelle")),
                  ElevatedButton(onPressed: yaziSil, child: const Text("Sil")),
                  ElevatedButton(
                      onPressed: yaziGetir, child: const Text("Getir")),
                ],
              ),
              ListTile(
                title: Text(gelenYaziBasligi),
                subtitle: Text(gelenYaziIcerigi),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
