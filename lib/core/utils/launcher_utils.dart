import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static const String whatsappNumber = '5522992834272';

  static Future<void> openWhatsApp({String message = ''}) async {
    final String url = 'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(message)}';
    final Uri uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
