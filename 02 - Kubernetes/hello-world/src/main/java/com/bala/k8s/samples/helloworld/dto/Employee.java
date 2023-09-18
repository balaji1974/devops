package com.bala.k8s.samples.helloworld.dto;

import java.net.InetAddress;
import java.net.UnknownHostException;

import org.springframework.stereotype.Component;

@Component
public class Employee {
	
	private String id;
	private String name;
	private Integer age;
	private String hostName;
	private Integer version;
	
	
	
	public Employee() throws UnknownHostException {
		super();
		this.id = "Emp01";
		this.name = "Balaji";
		this.age = 45;
		this.hostName = InetAddress.getLocalHost().getHostName();
		this.version= 3;
	}


	public String getId() {
		return id;
	}


	public void setId(String id) {
		this.id = id;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public Integer getAge() {
		return age;
	}


	public void setAge(Integer age) {
		this.age = age;
	}


	public String getHostName() {
		return hostName;
	}


	public void setHostName(String hostName) {
		this.hostName = hostName;
	}


	public Integer getVersion() {
		return version;
	}


	public void setVersion(Integer version) {
		this.version = version;
	}
	
}
