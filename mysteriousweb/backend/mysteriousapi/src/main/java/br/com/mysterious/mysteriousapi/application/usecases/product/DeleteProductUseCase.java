package br.com.mysterious.mysteriousapi.application.usecases.product;

import br.com.mysterious.mysteriousapi.application.exceptions.ProductNotFoundException;
import br.com.mysterious.mysteriousapi.persistence.repositories.ProductRepository;

public class DeleteProductUseCase {
    private final ProductRepository productRepository;

    public DeleteProductUseCase(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public void execute(Long id) throws ProductNotFoundException {
        if (!productRepository.existsById(id)) {
            throw new ProductNotFoundException("Product to delete not found");
        }

        productRepository.deleteById(id);
    }
}
