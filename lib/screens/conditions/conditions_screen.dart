import 'package:flutter/material.dart';

class ConditionsScreen extends StatelessWidget {
  static const String routeName = '/conditions';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => ConditionsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Condiciones y Privacidad'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'CONDICIONES DE USO Y POLÍTICA DE PRIVACIDAD\n1. El objetivo de la aplicación es compartir links de noticias y conversar sobre crianza infantil para compartir y debatir con otros progenitores cuestiones relacionadas con la educación de nuestros hijos.\n2. Está totalmente prohibido en la aplicación: subir contenido ofensivo (links, comentarios o imágenes), así como de carácter racista, sexista o erótico. En caso de hacerlo, su cuenta será bloqueada y eliminada inmediatamente. Sus datos serían eliminados.\n3. Crianza Mutua App en adelante “la app”, se reserva el derecho a dar de baja la aplicación en cualquier momento. Si se eliminara la aplicación de la Play Store o de la Apple Store, se eliminarán también todos los datos personales recopilados, así como links subidos y mensajes enviados.\n4. El único dato privado que se recopila es la dirección de correo electrónico. Nunca se cederán sus datos a terceros bajo ninguna circunstancia.\n5. En caso de eliminar la cuenta no podrá acceder a la misma pero su información no será eliminada. Si desea eliminar todo el contenido subido así como su correo electrónico, deberá de solicitarlo por mail a la cuenta: samuelfebreiro@gmail.com\n6. El responsable del tratamiento de los datos es Samuel Febreiro López. Puede ejercer sus derechos de acceso, rectificación, supresión y portabilidad de datos y oposición y limitación a su tratamiento ante Samuel Febreiro en la dirección de correo electrónico samuelfebreiro@gmail.com, adjuntando copia de su DNI o documento equivalente.\n7. Crianza Mutua App usa Firebase como servidor de los datos. Firebase es una empresa de Google Inc que ofrece recursos de alojamiento',
            style: TextStyle(color: Colors.black54, fontSize: 10.0),
          ),
        ),
      ),
    );
  }
}
