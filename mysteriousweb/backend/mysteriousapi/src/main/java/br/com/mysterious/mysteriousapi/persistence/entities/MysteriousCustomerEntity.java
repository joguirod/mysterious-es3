package br.com.mysterious.mysteriousapi.persistence.entities;

import br.com.mysterious.mysteriousapi.domain.entities.customer.MysteriousUser;
import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@EqualsAndHashCode
@ToString
public class MysteriousCustomerEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID mysteriousCustomerId;
    private String name;
    private String phone;
    @OneToOne
    private MysteriousUserEntity mysteriousUser;

    public MysteriousCustomerEntity() {
    }

    public MysteriousCustomerEntity(UUID mysteriousCustomerId, String name, String phone, MysteriousUserEntity mysteriousUser) {
        this.mysteriousCustomerId = mysteriousCustomerId;
        this.name = name;
        this.phone = phone;
        this.mysteriousUser = mysteriousUser;
    }

    public UUID getMysteriousCustomerId() {
        return mysteriousCustomerId;
    }

    public void setMysteriousCustomerId(UUID mysteriousCustomerId) {
        this.mysteriousCustomerId = mysteriousCustomerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public MysteriousUserEntity getMysteriousUser() {
        return mysteriousUser;
    }

    public void setMysteriousUser(MysteriousUserEntity mysteriousUser) {
        this.mysteriousUser = mysteriousUser;
    }
}
