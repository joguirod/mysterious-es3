package br.com.mysterious.mysteriousapi.domain.entities.orderAction;

import br.com.mysterious.mysteriousapi.domain.entities.customer.MysteriousUser;
import br.com.mysterious.mysteriousapi.domain.entities.order.Order;

import java.time.LocalDateTime;

public class OrderAction {
    private LocalDateTime actionDate;
    private String description;
    private OrderActionType actionType;
    private Order order;
    private MysteriousUser mysteriousUser;
}
