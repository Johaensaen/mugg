import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class MuggFirebaseUser {
  MuggFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

MuggFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<MuggFirebaseUser> muggFirebaseUserStream() => FirebaseAuth.instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<MuggFirebaseUser>((user) => currentUser = MuggFirebaseUser(user));
