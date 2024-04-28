import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'banda.dart';

class AgregarBandaScreen extends StatefulWidget {
  @override
  _AgregarBandaScreenState createState() => _AgregarBandaScreenState();
}

class _AgregarBandaScreenState extends State<AgregarBandaScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController albumController = TextEditingController();
  final TextEditingController anioController = TextEditingController();
  final picker = ImagePicker();
  File? _image;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _crearBanda(BuildContext context) {
    String nombre = nombreController.text;
    String album = albumController.text;
    int anio = int.tryParse(anioController.text) ?? 0;

    if (nombre.isNotEmpty && album.isNotEmpty && anio > 0) {
      String? imagePath;
      if (_image != null) {
        imagePath = _image!.path;
      }

      Banda nuevaBanda = Banda(
        nombre: nombre,
        album: album,
        anio: anio,
        imagen: imagePath ?? '', id: '',
      );
      Navigator.pop(context, nuevaBanda);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, completa todos los campos correctamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agregar Banda de Rock',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 24.0),
            Text(
              'Completa los datos',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la Banda',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: albumController,
              decoration: InputDecoration(
                labelText: 'Nombre del Álbum',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: anioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Año de Lanzamiento',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Seleccionar Foto del Álbum'),
            ),
            _image != null
                ? Image.file(_image!, height: 200)
                : SizedBox(height: 0),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _crearBanda(context);
              },
              child: Text('Agregar Banda'),
            ),
          ],
        ),
      ),
    );
  }
}
