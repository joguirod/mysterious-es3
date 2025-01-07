package br.com.mysterious.mysteriousapi.domain.entities.product;

public class Product {
    private Long id;
    private String productName;
    private int quantity;
    private Double price;
    private String description;

    public Product(Long id, String productName, int quantity, Double price, String description) {
        this.id = id;
        this.productName = productName;
        this.quantity = quantity;
        this.price = price;
        this.description = description;
    }

    public Product(String productName, int quantity, Double price, String description) {
        this.productName = productName;
        this.quantity = quantity;
        this.price = price;
        this.description = description;
    }

    public Product() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
