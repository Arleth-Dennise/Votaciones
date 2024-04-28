class Banda {
  final String id;
  final String nombre;
  final String album;
  final int anio;
  final int votos;
  final String imagen;

  Banda({required this.id, required this.nombre, required this.album, required this.anio, this.votos = 0, required this.imagen});
}
