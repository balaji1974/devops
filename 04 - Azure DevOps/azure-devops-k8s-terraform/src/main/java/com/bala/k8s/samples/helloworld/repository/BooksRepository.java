package com.bala.k8s.samples.helloworld.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.bala.k8s.samples.helloworld.dao.Books;

@Repository
public interface BooksRepository extends CrudRepository<Books, Integer> {

}



