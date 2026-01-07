import 'package:file_picker/file_picker.dart';

class DocumentItem {
  final int? id; // for already uploaded images
  final String? networkUrl; // for already uploaded images
  final PlatformFile? localFile; // for newly selected files

  const DocumentItem({this.id, this.networkUrl, this.localFile});
}
