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
public class PickUpLocationEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;
    private String adress;
    private String number;
    private String complement;
    private String city;
    private String state;
    // cep
    private String zip;

    public PickUpLocationEntity() {
    }

    public PickUpLocationEntity(UUID id, String adress, String number, String complement, String city, String state, String zip) {
        this.id = id;
        this.adress = adress;
        this.number = number;
        this.complement = complement;
        this.city = city;
        this.state = state;
        this.zip = zip;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getAdress() {
        return adress;
    }

    public void setAdress(String adress) {
        this.adress = adress;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getComplement() {
        return complement;
    }

    public void setComplement(String complement) {
        this.complement = complement;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getZip() {
        return zip;
    }

    public void setZip(String zip) {
        this.zip = zip;
    }
}
