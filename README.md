# Projetflutter

Rappel à paramétrer pour faire tourner l'application: 
```
compileSdkVersion 33
minSdkVersion 19
multiDexEnabled true
```

Règles sur Firebase :
```
rules_version = '2';
service cloud.firestore {
    match /databases/{database}/documents {
        match /users/{document=**} {
        allow read, write: if request.auth != null;
        }
    }
}
```