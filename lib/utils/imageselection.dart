import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker i = ImagePicker();
  XFile? file = await i.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}
