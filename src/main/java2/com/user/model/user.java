package com.user.model;

public class user {
      private int user_id;
      private String username;
      private String password;
      private String email;
	public user() {
		super();
		// TODO Auto-generated constructor stub
	}
	public user(int user_id, String username, String password, String email) {
		super();
		this.user_id = user_id;
		this.username = username;
		this.password = password;
		this.email = email;
	}
	public int getUser_id() {
		return user_id;
	}
	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	@Override
	public String toString() {
		return "user [user_id=" + user_id + ", username=" + username + ", password=" + password + ", email=" + email
				+ "]";
	}
      
}
