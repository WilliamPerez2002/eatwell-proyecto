// ignore_for_file: file_names

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:random_string/random_string.dart';

class EmailSender {
  String generateRandomPassword() {
    // Genera una cadena de 10 caracteres alfanuméricos
    String password = randomAlphaNumeric(10);
    return password;
  }

  Future<String?> sendEmail(String recipientEmail, String name) async {
    try {
      final smtpServer = gmail('eatwell20023@gmail.com', 'erowwyhaziujeuww');

      String password = generateRandomPassword();

      final message = Message()
        ..from = const Address('eatwell20023@gmail.com', 'EatWell')
        ..recipients.add(recipientEmail)
        ..subject = "Recuperacion de la contraseña"
        ..html = '''
        <center><h1 style="color: #4b4452;">Hola $name,</h1>
        <p style="font-size: 18px; color: #4b4452; ">Este es un mensaje de recuperacion de contraseña</p>
        <p style="font-size: 18px;">Tu nueva contraseña es: <span style="font-weight: bold;">$password</span></p></center>
      ''';

      final sendReport = await send(message, smtpServer);
      print('Correo electrónico enviado: ${sendReport.toString()}');
      return password;
    } catch (error) {
      print('Error al enviar el correo electrónico: $error');
      return null;
    }
  }
}
