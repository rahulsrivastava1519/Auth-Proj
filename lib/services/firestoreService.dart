import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

fireStoreCommonService() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: const FirebaseOptions(
      googleAppID:  '1:649068837817:android:0455902cddb675704e1468',
      gcmSenderID: '649068837817',
      apiKey: 'AIzaSyDSjXC9665gBtcf_mLw-6ehMml7rdm5q1w',
      projectID: 'auth-project-cbb51',
    ),
  );
  final Firestore firestore = Firestore(app: app);
  return firestore;
}
