package br.com.mysterious.mysteriousapi.application.exceptions;

public class RequiredValueException extends Exception {
    public RequiredValueException(String message) {
        super(message);
    }
}
