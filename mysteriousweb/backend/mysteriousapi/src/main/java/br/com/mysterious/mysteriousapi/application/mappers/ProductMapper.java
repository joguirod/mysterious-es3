package br.com.mysterious.mysteriousapi.application.mappers;

import br.com.mysterious.mysteriousapi.domain.entities.product.Product;
import br.com.mysterious.mysteriousapi.persistence.entities.ProductEntity;

public class ProductMapper {
    public ProductEntity toEntity(Product product) {
        ProductEntity productEntity = new ProductEntity();
        productEntity.setProductId(product.getId());
        productEntity.setProductName(product.getProductName());
        productEntity.setDescription(product.getDescription());
        productEntity.setPrice(product.getPrice());
        productEntity.setQuantity(product.getQuantity());
        return productEntity;
    }

    public Product toDomainObject(ProductEntity productEntity) {
        Product product = new Product();
        product.setId(productEntity.getProductId());
        product.setProductName(productEntity.getProductName());
        product.setDescription(productEntity.getDescription());
        product.setPrice(productEntity.getPrice());
        product.setQuantity(productEntity.getQuantity());
        return product;
    }
}
