package br.com.mysterious.mysteriousapi.domain.entities.order;

import br.com.mysterious.mysteriousapi.domain.entities.cart.Cart;
import br.com.mysterious.mysteriousapi.domain.entities.customer.MysteriousCustomer;

import java.time.LocalDateTime;
import java.util.List;

public class Order {
    private LocalDateTime orderDate;
    private Cart cart;
    private MysteriousCustomer mysteriousCustomer;
    private OrderStatus orderStatus;
    private PickUpLocation pickUpLocation;
}
