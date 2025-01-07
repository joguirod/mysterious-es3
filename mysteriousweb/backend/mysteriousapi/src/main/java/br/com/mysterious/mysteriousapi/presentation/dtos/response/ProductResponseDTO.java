package br.com.mysterious.mysteriousapi.presentation.dtos.response;

public class ProductResponseDTO {
    private Long id;
    private String name;
    private int quantity;
    private Double price;
    private String description;

    public ProductResponseDTO() {
    }

    public ProductResponseDTO(Long id, String name, int quantity, Double price, String description) {
        this.id = id;
        this.name = name;
        this.quantity = quantity;
        this.price = price;
        this.description = description;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
