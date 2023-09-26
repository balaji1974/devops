package com.bala.k8s.samples.helloworld.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bala.k8s.samples.helloworld.dao.Books;
import com.bala.k8s.samples.helloworld.repository.BooksRepository;

@Service
public class BooksService {
	
	@Autowired
	BooksRepository booksRepository;
	
	public List<Books> findAll() {
        List<Books> books=new ArrayList<>();
		booksRepository.findAll().forEach(books::add);
        return books;
    }

}


