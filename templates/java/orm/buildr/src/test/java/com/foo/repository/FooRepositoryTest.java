package com.foo.repository;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static com.google.common.collect.Iterables.contains;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:repository.xml")
public class FooRepositoryTest {
    @Autowired
    private FooRepository repository;

    @Before
    public void setUp() {
        repository.deleteAll();
    }

	@Test
    public void should_find_foo() {
        FooEntity entity = new FooEntity("foo", 30, "bar");
        repository.save(entity);

        Iterable<FooEntity> entities = repository.findAll();
        assertThat(contains(entities, entity), is(true));
    }
}