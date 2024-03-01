import 'package:c_supervisor/provider/license_provider.dart';
import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';

class DonwloadFile {
  Future<void> getFile(String fileName) async {
    final storageIO = InternetFileStorageIO();

    print(LicenseProvider.imageBasePath);

    await InternetFile.get(
      "${LicenseProvider.imageBasePath}knowledge_share/$fileName",
      storage: storageIO,
      storageAdditional: storageIO.additional(
        filename: fileName,
        location: '',
      ),
      force: true,
      progress: (receivedLength, contentLength) {
        final percentage = receivedLength / contentLength * 100;
        print(
            'download progress: $receivedLength of $contentLength ($percentage%)');
      },
    );
  }
}
