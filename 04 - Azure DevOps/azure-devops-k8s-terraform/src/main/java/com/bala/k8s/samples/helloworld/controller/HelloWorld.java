package com.bala.k8s.samples.helloworld.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bala.k8s.samples.helloworld.dto.Employee;

@RestController
@RequestMapping("sample")
public class HelloWorld {
	
	@Autowired
	Employee employee;
	
	@GetMapping("/") // For checking the readiness and liveliness of the microservices from the yaml file 
	public String imHealthy() {
		return "{healthy:true}";
	}
	
	@GetMapping(value="/employee", produces = "application/json")
	public Employee getEmployee() {
		return employee;
	}
}
