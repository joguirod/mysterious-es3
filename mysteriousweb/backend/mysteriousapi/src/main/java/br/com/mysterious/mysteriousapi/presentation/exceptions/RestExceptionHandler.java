package br.com.mysterious.mysteriousapi.presentation.exceptions;

import br.com.mysterious.mysteriousapi.application.exceptions.NonPositiveNumberException;
import br.com.mysterious.mysteriousapi.application.exceptions.ProductNotFoundException;
import br.com.mysterious.mysteriousapi.application.exceptions.RequiredValueException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@ControllerAdvice
public class RestExceptionHandler extends ResponseEntityExceptionHandler {
    @ExceptionHandler(ProductNotFoundException.class)
    private ResponseEntity<HttpExceptionMessage> ProductNotFoundException(ProductNotFoundException e) {
        HttpExceptionMessage exceptionResponse = new HttpExceptionMessage(e.getMessage(), HttpStatus.NOT_FOUND);
        return new ResponseEntity<>(exceptionResponse, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(NonPositiveNumberException.class)
    private ResponseEntity<HttpExceptionMessage> NonPositiveNumberException(NonPositiveNumberException e) {
        HttpExceptionMessage exceptionResponse = new HttpExceptionMessage(e.getMessage(), HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(exceptionResponse, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(RequiredValueException.class)
    private ResponseEntity<HttpExceptionMessage> RequiredValueException(RequiredValueException e) {
        HttpExceptionMessage exceptionResponse = new HttpExceptionMessage(e.getMessage(), HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(exceptionResponse, HttpStatus.BAD_REQUEST);
    }
}
