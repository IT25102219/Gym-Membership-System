package com.gym.model;

import com.gym.interfaces.Displayable;




    public abstract class Person implements Displayable {


        private int personId;


        private String name;

        private String email;


        private String phone;


        public Person(int personId, String name, String email, String phone) {
            // Assign each parameter to the corresponding private field
            this.personId = personId;
            this.name = name;
            this.email = email;
            this.phone = phone;
        }


        public Person() {}


        public int getPersonId() {
            return personId;
        }

        public String getName() {
            return name;
        }


        public String getEmail() {
            return email;
        }


        public String getPhone() {
            return phone;
        }

        public void setPersonId(int personId) {
            this.personId = personId;
        }

        public void setName(String name) {
            this.name = name;
        }


        public void setEmail(String email) {
            this.email = email;
        }


        public void setPhone(String phone) {
            this.phone = phone;
        }


        @Override
        public abstract String getRole();


        @Override
        public abstract String getDisplayInfo();

        @Override
        public String toString() {
            return "Person{id=" + personId + ", name='" + name + "', email='" + email + "'}";
        }
    }


