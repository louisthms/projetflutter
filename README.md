# projetflutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Rappel à paramétrer pour faire tourner l'application: 

compileSdkVersion 33
minSdkVersion 19
multiDexEnabled true


Compte Google pour Firebase :
projetflutter@gmail.com 
*********

Règles sur Firebase :
rules_version = '2';
service cloud.firestore {
match /databases/{database}/documents {
match /users/{document=**} {
allow read, write: if request.auth != null;
}
}
}