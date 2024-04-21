import 'package:flutter/material.dart';

void main() {
  runApp(VotacionesApp());
}

class VotacionesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votaciones de Bandas de Rock',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      debugShowCheckedModeBanner: false,
      home: BandasScreen(),
    );
  }
}

class BandasScreen extends StatefulWidget {
  @override
  _BandasScreenState createState() => _BandasScreenState();
}

class _BandasScreenState extends State<BandasScreen> {
  List<Banda> bandas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bandas de Rock',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.0),
              ...bandas.map((banda) => BandTile(
                banda: banda,
                onTap: () {
                  setState(() {
                    banda.votar();
                  });
                },
              )).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _agregarBanda(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green[200],
      ),
    );
  }

  void _agregarBanda(BuildContext context) async {
    Banda nuevaBanda = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AgregarBandaScreen()),
    );
    if (nuevaBanda != null) {
      setState(() {
        bandas.add(nuevaBanda);
      });
    }
  }
}

class BandTile extends StatelessWidget {
  final Banda banda;
  final VoidCallback onTap;

  BandTile({required this.banda, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(banda.imagen),
              ),
              Text(
                banda.nombre,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Álbum: ${banda.album} (${banda.anio})',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.0),
              ),
              Text(
                '${banda.votos} votos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgregarBandaScreen extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController albumController = TextEditingController();
  final TextEditingController anioController = TextEditingController();

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
      body: Container(
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

  void _crearBanda(BuildContext context) {
    String nombre = nombreController.text;
    String album = albumController.text;
    int anio = int.tryParse(anioController.text) ?? 0;

    if (nombre.isNotEmpty && album.isNotEmpty && anio > 0) {
      Banda nuevaBanda = Banda(
        nombre: nombre,
        album: album,
        anio: anio,
        imagen: '',
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
}

class Banda {
  String nombre;
  String album;
  int anio;
  int votos;
  String imagen;

  Banda({required this.nombre, required this.album, required this.anio, this.votos = 0, required this.imagen});

  void votar() {
    votos++;
  }
}
