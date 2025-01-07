package br.com.mysterious.mysteriousapi.persistence.entities;

import br.com.mysterious.mysteriousapi.domain.entities.cart.Cart;
import br.com.mysterious.mysteriousapi.domain.entities.customer.MysteriousCustomer;
import br.com.mysterious.mysteriousapi.domain.entities.order.OrderStatus;
import br.com.mysterious.mysteriousapi.domain.entities.order.PickUpLocation;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@EqualsAndHashCode
@ToString
public class OrderEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID orderId;
    private LocalDateTime orderDate;
    @OneToOne
    private CartEntity cart;
    @ManyToOne
    private MysteriousCustomerEntity mysteriousCustomer;
    private OrderStatus orderStatus;
    @ManyToOne
    private PickUpLocationEntity pickUpLocation;

    public OrderEntity() {
    }

    public OrderEntity(UUID orderId, LocalDateTime orderDate, CartEntity cart, MysteriousCustomerEntity mysteriousCustomer, OrderStatus orderStatus, PickUpLocationEntity pickUpLocation) {
        this.orderId = orderId;
        this.orderDate = orderDate;
        this.cart = cart;
        this.mysteriousCustomer = mysteriousCustomer;
        this.orderStatus = orderStatus;
        this.pickUpLocation = pickUpLocation;
    }

    public UUID getOrderId() {
        return orderId;
    }

    public void setOrderId(UUID orderId) {
        this.orderId = orderId;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public CartEntity getCart() {
        return cart;
    }

    public void setCart(CartEntity cart) {
        this.cart = cart;
    }

    public MysteriousCustomerEntity getMysteriousCustomer() {
        return mysteriousCustomer;
    }

    public void setMysteriousCustomer(MysteriousCustomerEntity mysteriousCustomer) {
        this.mysteriousCustomer = mysteriousCustomer;
    }

    public OrderStatus getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(OrderStatus orderStatus) {
        this.orderStatus = orderStatus;
    }

    public PickUpLocationEntity getPickUpLocation() {
        return pickUpLocation;
    }

    public void setPickUpLocation(PickUpLocationEntity pickUpLocation) {
        this.pickUpLocation = pickUpLocation;
    }
}
