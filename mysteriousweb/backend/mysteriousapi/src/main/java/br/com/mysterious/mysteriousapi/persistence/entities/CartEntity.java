package br.com.mysterious.mysteriousapi.persistence.entities;

import br.com.mysterious.mysteriousapi.domain.entities.cart.CartStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@EqualsAndHashCode
@ToString
public class CartEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long cartId;
    private CartStatus status;
    @ManyToOne
    private MysteriousCustomerEntity customer;
    @OneToMany
    private List<CartItemEntity> items;
    private LocalDateTime finishedAt;

    public CartEntity() {
    }

    public CartEntity(Long cartId, CartStatus status, MysteriousCustomerEntity customer, List<CartItemEntity> items, LocalDateTime finishedAt) {
        this.cartId = cartId;
        this.status = status;
        this.customer = customer;
        this.items = items;
        this.finishedAt = finishedAt;
    }

    public Long getCartId() {
        return cartId;
    }

    public void setCartId(Long cartId) {
        this.cartId = cartId;
    }

    public CartStatus getStatus() {
        return status;
    }

    public void setStatus(CartStatus status) {
        this.status = status;
    }

    public MysteriousCustomerEntity getCustomer() {
        return customer;
    }

    public void setCustomer(MysteriousCustomerEntity customer) {
        this.customer = customer;
    }

    public List<CartItemEntity> getItems() {
        return items;
    }

    public void setItems(List<CartItemEntity> items) {
        this.items = items;
    }

    public LocalDateTime getFinishedAt() {
        return finishedAt;
    }

    public void setFinishedAt(LocalDateTime finishedAt) {
        this.finishedAt = finishedAt;
    }
}
