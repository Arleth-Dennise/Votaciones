import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'band_tile.dart';
import 'agregar_banda_screen.dart';
import 'firebase_service.dart';
import 'banda.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      body: StreamBuilder<List<Banda>>(
        stream: FirebaseService.obtenerBandas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<Banda> bandas = snapshot.data ?? [];
          return ListView.builder(
            itemCount: bandas.length,
            itemBuilder: (context, index) {
              return BandTile(
                banda: bandas[index],
                onTap: () {
                  FirebaseService.votarBanda(bandas[index]);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarBandaScreen()),
          ).then((nuevaBanda) {
            if (nuevaBanda != null) {
              FirebaseService.agregarBanda(nuevaBanda);
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green[200],
      ),
    );
  }
}
