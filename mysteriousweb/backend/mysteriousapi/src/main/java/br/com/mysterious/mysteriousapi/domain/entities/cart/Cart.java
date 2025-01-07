package br.com.mysterious.mysteriousapi.domain.entities.cart;

import br.com.mysterious.mysteriousapi.domain.entities.customer.MysteriousCustomer;

import java.time.LocalDateTime;
import java.util.List;

public class Cart {
    private CartStatus status;
    private MysteriousCustomer customer;
    private List<CartItem> items;
    private LocalDateTime finishedAt;
}
