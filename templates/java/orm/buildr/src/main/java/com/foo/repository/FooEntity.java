package com.foo.repository;

import com.google.common.base.Objects;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class FooEntity {
    @Id
    private long id;

    private String name;
    private int bar;
    private String data;

    public FooEntity() {
    }

    public FooEntity(String name, int bar, String data) {
        this.name = name;
        this.bar = bar;
        this.data = data;
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof FooEntity)) {
            return false;
        }

        FooEntity that = (FooEntity)obj;
        return Objects.equal(name, that.name) && Objects.equal(bar, that.bar) && Objects.equal(data, that.data);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(name, bar, data);
    }

    public String getName(){
        return this.name;
    }

    public String getData(){
        return this.data;
    }
}
