package br.com.mysterious.mysteriousapi.persistence.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

import java.util.UUID;

@Entity
@EqualsAndHashCode
@ToString
public class MysteriousUserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID mysteriousUserId;
    private String username;
    private String email;
    private String password;

    public MysteriousUserEntity() {
    }

    public MysteriousUserEntity(UUID mysteriousUserId, String username, String email, String password) {
        this.mysteriousUserId = mysteriousUserId;
        this.username = username;
        this.email = email;
        this.password = password;
    }

    public UUID getMysteriousUserId() {
        return mysteriousUserId;
    }

    public void setMysteriousUserId(UUID mysteriousUserId) {
        this.mysteriousUserId = mysteriousUserId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
