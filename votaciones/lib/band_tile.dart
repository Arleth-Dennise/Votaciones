import 'package:flutter/material.dart';
import 'banda.dart';

class BandTile extends StatelessWidget {
  final Banda banda;
  final VoidCallback onTap;

  const BandTile({required this.banda, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: banda.imagen.isNotEmpty ? Image.network(banda.imagen, height: 50, width: 50) : Placeholder(),
      title: Text(banda.nombre),
      subtitle: Text('${banda.album} - ${banda.anio}'),
      trailing: Text('Votos: ${banda.votos}'),
    );
  }
}
