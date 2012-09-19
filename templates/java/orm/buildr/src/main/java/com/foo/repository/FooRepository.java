package com.foo.repository;

import org.springframework.data.repository.CrudRepository;

public interface FooRepository extends CrudRepository<FooEntity, Long> {
}