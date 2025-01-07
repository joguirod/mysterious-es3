package br.com.mysterious.mysteriousapi.persistence.entities;

import br.com.mysterious.mysteriousapi.domain.entities.cart.CartItemStatus;
import jakarta.persistence.*;
import lombok.*;

@Entity
@EqualsAndHashCode
@ToString
public class CartItemEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long cartItemId;
    @OneToOne
    private CartEntity cart;
    private CartItemStatus itemStatus;
    @OneToOne
    private ProductEntity product;

    public CartItemEntity() {
    }

    public CartItemEntity(Long cartItemId, CartEntity cart, CartItemStatus itemStatus, ProductEntity product) {
        this.cartItemId = cartItemId;
        this.cart = cart;
        this.itemStatus = itemStatus;
        this.product = product;
    }

    public Long getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(Long cartItemId) {
        this.cartItemId = cartItemId;
    }

    public CartEntity getCart() {
        return cart;
    }

    public void setCart(CartEntity cart) {
        this.cart = cart;
    }

    public CartItemStatus getItemStatus() {
        return itemStatus;
    }

    public void setItemStatus(CartItemStatus itemStatus) {
        this.itemStatus = itemStatus;
    }

    public ProductEntity getProduct() {
        return product;
    }

    public void setProduct(ProductEntity product) {
        this.product = product;
    }
}
