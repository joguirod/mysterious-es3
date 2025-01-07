package br.com.mysterious.mysteriousapi.domain.entities.cart;

import br.com.mysterious.mysteriousapi.domain.entities.product.Product;

public class CartItem {
    private Cart cart;
    private CartItemStatus itemStatus;
    private Product product;
}
