package com.paysync.backend.controller;

import com.paysync.backend.models.Transaction;
import com.paysync.backend.services.TransactionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/transactions")
public class TransactionController {

    private final TransactionService transactionService;

    public TransactionController(TransactionService transactionService) {
        this.transactionService = transactionService;
    }

    @PostMapping("/add")
    public ResponseEntity<String> addTransaction(@RequestParam String uid, @RequestBody Transaction transaction) throws ExecutionException, InterruptedException {
        String transactionId = transactionService.addTransaction(uid, transaction);
        return ResponseEntity.ok("Transaction created with ID: " + transactionId);
    }
     
    @GetMapping("/get")
    public ResponseEntity<Transaction> getTransaction(
          @RequestParam String uid,
          @RequestParam String transactionId
    ) throws InterruptedException, ExecutionException {
        Transaction tx = transactionService.getTransaction(uid, transactionId);
        if (tx == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(tx);
    }
    
    @GetMapping("/all")
    public ResponseEntity<List<Transaction>> getAllTransactions(@RequestParam String uid) throws ExecutionException, InterruptedException {
        List<Transaction> transactions = transactionService.getAllTransactions(uid);
        return ResponseEntity.ok(transactions);
    }

    @PutMapping("/update")
    public ResponseEntity<String> updateTransaction(@RequestParam String uid, @RequestParam String transactionId, @RequestBody Transaction transaction) throws ExecutionException, InterruptedException {
        String result = transactionService.updateTransaction(uid, transactionId, transaction);
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<String> deleteTransaction(@RequestParam String uid, @RequestParam String transactionId) throws ExecutionException, InterruptedException {
        String result = transactionService.deleteTransaction(uid, transactionId);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/test")
    public ResponseEntity<String> transactionsGetEndpoint() {
        return ResponseEntity.ok("Transactions endpoint is working!");
    }
}
