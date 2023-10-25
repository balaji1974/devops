package com.bala.k8s.samples.helloworld.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class HelloWorld {
	
	
	@GetMapping("/helloworld") 
	public String helloWorld() {
		return "Hello World";
	}
}
