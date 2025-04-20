package com.paysync.backend.services;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import com.paysync.backend.models.User;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

@Service
public class UserService {

    public String createUser(User user) throws InterruptedException, ExecutionException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        ApiFuture<com.google.cloud.firestore.WriteResult> collectionsApiFuture = dbFirestore
                .collection("users")
                .document(user.getUid())
                .set(user);
        return collectionsApiFuture.get().getUpdateTime().toString();
    }

    public User getUser(String uid) throws InterruptedException, ExecutionException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        DocumentReference documentReference = dbFirestore.collection("users").document(uid);
        ApiFuture<com.google.cloud.firestore.DocumentSnapshot> future = documentReference.get();
        com.google.cloud.firestore.DocumentSnapshot document = future.get();
        if (document.exists()) {
            User user = document.toObject(User.class);
            return user;
        } else {
            return null;
        }
    }

    public String updateUser(User user) throws InterruptedException, ExecutionException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        ApiFuture<com.google.cloud.firestore.WriteResult> future = dbFirestore
                .collection("users")
                .document(user.getUid())
                .set(user); // Overwrites or updates the document
        return future.get().getUpdateTime().toString();
    }

    public User deleteUser(String uid) throws InterruptedException, ExecutionException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        DocumentReference docRef = dbFirestore.collection("users").document(uid);

        ApiFuture<com.google.cloud.firestore.DocumentSnapshot> future = docRef.get();
        com.google.cloud.firestore.DocumentSnapshot document = future.get();

        if (document.exists()) {
            User user = document.toObject(User.class);
            docRef.delete();
            return user;
        } else {
            return null;
        }
    }
}
