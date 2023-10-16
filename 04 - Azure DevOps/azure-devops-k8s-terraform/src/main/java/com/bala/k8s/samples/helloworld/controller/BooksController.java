package com.bala.k8s.samples.helloworld.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bala.k8s.samples.helloworld.dao.Books;
import com.bala.k8s.samples.helloworld.service.BooksService;

@RestController
public class BooksController {
	@Autowired
	BooksService booksService;

	@GetMapping("/books")
	public ResponseEntity<List<Books>> allBooks() {
	    List<Books> books = booksService.findAll();
	    return new ResponseEntity<>(books, HttpStatus.OK);
	}
	
}


