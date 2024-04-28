import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'banda.dart';

class FirebaseService {
  static Stream<List<Banda>> obtenerBandas() {
    return FirebaseFirestore.instance.collection('bandas').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Banda(
          id: doc.id,
          nombre: doc['nombre'],
          album: doc['album'],
          anio: doc['anio'],
          votos: doc['votos'] ?? 0,
          imagen: doc['imagen'],
        );
      }).toList();
    });
  }

  static void agregarBanda(Banda banda) async {
    String imageUrl = await _subirImagen(banda.imagen);
    await FirebaseFirestore.instance.collection('bandas').add({
      'nombre': banda.nombre,
      'album': banda.album,
      'anio': banda.anio,
      'votos': banda.votos,
      'imagen': imageUrl,
    });
  }

  static void votarBanda(Banda banda) {
    int nuevosVotos = banda.votos + 1;
    FirebaseFirestore.instance.collection('bandas').doc(banda.id).update({'votos': nuevosVotos});
  }

  static Future<String> _subirImagen(String imagePath) async {
    if (imagePath.isEmpty) {
      return '';
    }

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('albums').child(imagePath);
    firebase_storage.UploadTask uploadTask = ref.putFile(File(imagePath));
    await uploadTask;
    return await ref.getDownloadURL();
  }
}
