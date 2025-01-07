package br.com.mysterious.mysteriousapi.persistence.entities;

import br.com.mysterious.mysteriousapi.domain.entities.customer.MysteriousUser;
import br.com.mysterious.mysteriousapi.domain.entities.order.Order;
import br.com.mysterious.mysteriousapi.domain.entities.orderAction.OrderActionType;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@EqualsAndHashCode
@ToString
public class OrderActionEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long orderActionId;
    private LocalDateTime actionDate;
    private String description;
    private OrderActionType actionType;
    @ManyToOne
    private OrderEntity order;
    @ManyToOne
    private MysteriousUserEntity mysteriousUser;

    public OrderActionEntity() {
    }

    public OrderActionEntity(Long orderActionId, LocalDateTime actionDate, String description, OrderActionType actionType, OrderEntity order, MysteriousUserEntity mysteriousUser) {
        this.orderActionId = orderActionId;
        this.actionDate = actionDate;
        this.description = description;
        this.actionType = actionType;
        this.order = order;
        this.mysteriousUser = mysteriousUser;
    }

    public Long getOrderActionId() {
        return orderActionId;
    }

    public void setOrderActionId(Long orderActionId) {
        this.orderActionId = orderActionId;
    }

    public LocalDateTime getActionDate() {
        return actionDate;
    }

    public void setActionDate(LocalDateTime actionDate) {
        this.actionDate = actionDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public OrderActionType getActionType() {
        return actionType;
    }

    public void setActionType(OrderActionType actionType) {
        this.actionType = actionType;
    }

    public OrderEntity getOrder() {
        return order;
    }

    public void setOrder(OrderEntity order) {
        this.order = order;
    }

    public MysteriousUserEntity getMysteriousUser() {
        return mysteriousUser;
    }

    public void setMysteriousUser(MysteriousUserEntity mysteriousUser) {
        this.mysteriousUser = mysteriousUser;
    }
}
