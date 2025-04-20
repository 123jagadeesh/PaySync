package com.paysync.backend.services;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import com.paysync.backend.models.Transaction;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class TransactionService {

    public String addTransaction(String uid, Transaction transaction) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference userRef = db.collection("users").document(uid);
        ApiFuture<DocumentReference> future = userRef.collection("transactions").add(transaction);
        return future.get().getId();
    }

    public List<Transaction> getAllTransactions(String uid) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        ApiFuture<QuerySnapshot> future = db.collection("users")
                                            .document(uid)
                                            .collection("transactions")
                                            .get();

                                            List<Transaction> transactions = new ArrayList<>();
                                            for (QueryDocumentSnapshot doc : future.get().getDocuments()) {
                                                Transaction tx = doc.toObject(Transaction.class);
                                                tx.setId(doc.getId());
                                                transactions.add(tx);
                                            }
                                            return transactions;
                                        }
    

            public Transaction getTransaction(String uid, String transactionId) throws ExecutionException, InterruptedException {
                Firestore db = FirestoreClient.getFirestore();
                DocumentReference docRef = db.collection("users")
                                                .document(uid)
                                                .collection("transactions")
                                                .document(transactionId);
                DocumentSnapshot document = docRef.get().get();
                
                if (document.exists()) {
                    Transaction transaction = document.toObject(Transaction.class);
                    if (transaction != null) {
                        transaction.setId(document.getId()); // Add the ID to the object
                    }
                    return transaction;
                } else {
                    return null;
                                            }
                                        }
                                        
    public String updateTransaction(String uid, String transactionId, Transaction transaction) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> future = db.collection("users")
                                          .document(uid)
                                          .collection("transactions")
                                          .document(transactionId)
                                          .set(transaction);
        return future.get().getUpdateTime().toString();
    }

    public String deleteTransaction(String uid, String transactionId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> future = db.collection("users")
                                          .document(uid)
                                          .collection("transactions")
                                          .document(transactionId)
                                          .delete();
        return future.get().getUpdateTime().toString();
    }
}
