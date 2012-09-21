package com.foo.repository;

import org.junit.Test;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

public class FooEntityTest {
    @Test
    public void should_not_be_equal_to_null() {
        FooEntity entity = new FooEntity();
        assertThat(entity.equals(null), is(false));
    }

    @Test
    public void should_be_equal_to_same_entity() {
        FooEntity source = new FooEntity("foo", 0, "data");
        FooEntity target = new FooEntity("foo", 0, "data");
        assertThat(source.equals(target), is(true));
    }

    @Test
    public void should_not_be_equal_to_entity_with_different_foo() {
        FooEntity source = new FooEntity("foo", 0, "data");
        FooEntity target = new FooEntity("different", 0, "data");
        assertThat(source.equals(target), is(false));
    }

    @Test
    public void should_not_be_equal_to_entity_with_different_bar() {
        FooEntity source = new FooEntity("foo", 0, "data");
        FooEntity target = new FooEntity("foo", 1, "data");
        assertThat(source.equals(target), is(false));
    }

    @Test
    public void should_not_be_equal_to_entity_with_different_data() {
        FooEntity source = new FooEntity("foo", 0, "data");
        FooEntity target = new FooEntity("foo", 0, "different");
        assertThat(source.equals(target), is(false));
    }

    @Test
    public void should_be_same_hashcode() {
        FooEntity source = new FooEntity("foo", 0, "data");
        FooEntity target = new FooEntity("foo", 0, "data");
        assertThat(source.hashCode(), is(target.hashCode()));
    }
}
