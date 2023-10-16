package com.bala.k8s.samples.helloworld.dao;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;


@Entity
@Data
public class Books {
	
	@Id
	@Column(name = "book_id")
	private String bookId;
	
	@Column(name = "book_name")
	private String bookName;
	
	@Column(name = "type")
	private String bookType;

}
